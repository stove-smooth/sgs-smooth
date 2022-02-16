package com.example.communityserver.service;

import com.example.communityserver.client.ChatClient;
import com.example.communityserver.client.UserClient;
import com.example.communityserver.domain.*;
import com.example.communityserver.domain.type.CommonStatus;
import com.example.communityserver.domain.type.CommunityMemberStatus;
import com.example.communityserver.dto.request.*;
import com.example.communityserver.dto.response.*;
import com.example.communityserver.domain.type.ChannelType;
import com.example.communityserver.domain.type.CommunityRole;
import com.example.communityserver.exception.CustomException;
import com.example.communityserver.repository.CommunityInvitationRepository;
import com.example.communityserver.repository.CommunityMemberRepository;
import com.example.communityserver.repository.CommunityRepository;
import com.example.communityserver.repository.RoomMemberRepository;
import com.example.communityserver.util.AmazonS3Connector;
import com.example.communityserver.util.Base62;
import com.example.communityserver.util.UserStateUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

import static com.example.communityserver.domain.Category.createCategory;
import static com.example.communityserver.domain.Channel.createChannel;
import static com.example.communityserver.domain.CommunityMember.createCommunityMember;
import static com.example.communityserver.dto.response.MemberResponse.fromEntity;
import static com.example.communityserver.exception.CustomExceptionStatus.*;
import static com.example.communityserver.service.ChannelService.CHANNEL_DEFAULT_NAME;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CommunityService {

    @Value("${smooth.url}")
    private String HOST_ADDRESS;
    private static final String COMMUNITY_INVITATION_PREFIX = "/c/";
    private static final String COMMUNITY = "community/";
    private static final String DIRECT = "direct/";

    private final CommunityRepository communityRepository;
    private final CommunityMemberRepository communityMemberRepository;
    private final CommunityInvitationRepository communityInvitationRepository;
    private final RoomMemberRepository roomMemberRepository;

    private final AmazonS3Connector amazonS3Connector;
    private final Base62 base62;

    private final UserClient userClient;
    private final ChatClient chatClient;

    @Transactional
    public CommunityResponse createCommunity(
            Long userId,
            CreateCommunityRequest request,
            String token
    ) {
        String iconImage = null;
        if (!Objects.isNull(request.getIcon()))
            iconImage = amazonS3Connector.uploadImage(userId, request.getIcon());

        // 기본 생성되는 카테고리
        Category voiceCategory = makeDefaultCategory(ChannelType.VOICE, null);
        Category textCategory = makeDefaultCategory(ChannelType.TEXT, voiceCategory);

        Community newCommunity = Community.createCommunity(
                request.getName(), iconImage, request.isPublic(), textCategory, voiceCategory);

        // 생성한 유저 정보 불러오기
        // Todo auth 터졌을 때 예외 처리
        // Todo feign config로 처리하기 controller, servive, userclient
        UserInfoFeignResponse userInfoFeignResponse = userClient.getUserInfo(token);
        String nickname = userInfoFeignResponse.getResult().getName();
        String profileImage = userInfoFeignResponse.getResult().getProfileImage();

        // 순서 배치를 위해 첫 번째로 위치한 노드 찾기
        CommunityMember firstNode = getFirstNode(userId);
        
        // 생성
        createCommunityMember(userId, newCommunity, nickname, profileImage, firstNode, CommunityRole.OWNER);
        communityRepository.save(newCommunity);

        return CommunityResponse.fromEntity(newCommunity);
    }

    private Category makeDefaultCategory(ChannelType channelType, Category nextNode) {
        Category category = createCategory(channelType.getDescription(), true, nextNode, null);
        createChannel(category, channelType, CHANNEL_DEFAULT_NAME, true, null, null);
        return category;
    }

    @Transactional
    public void editName(Long userId, EditNameRequest request) {

        Community community = communityRepository.findById(request.getId())
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_COMMUNITY));

        isOwner(community, userId);

        community.setName(request.getName());
    }

    private void isAuthorizedMember(Community community, Long userId) {
        boolean isAuthorization = community.getMembers().stream()
                .filter(communityMember -> communityMember.getStatus().equals(CommunityMemberStatus.NORMAL))
                .map(CommunityMember::getUserId)
                .collect(Collectors.toList())
                .contains(userId);

        if (!isAuthorization)
            throw new CustomException(NON_AUTHORIZATION);
    }

    private void isOwner(Community community, Long userId) {
        if (!getOwnerUserId(community).equals(userId))
            throw new CustomException(NON_AUTHORIZATION);
    }

    private Long getOwnerUserId(Community community) {
        return community.getMembers().stream()
                .filter(cm -> cm.getRole().equals(CommunityRole.OWNER))
                .findFirst().orElseThrow(() -> new CustomException(NON_EXIST_OWNER))
                .getUserId();
    }

    @Transactional
    public void editIcon(Long userId, EditIconRequest request) {

        Community community = communityRepository.findById(request.getId())
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_COMMUNITY));

        isOwner(community, userId);

        String iconImage = null;
        if (!Objects.isNull(request.getIcon()))
            iconImage = amazonS3Connector.uploadImage(userId, request.getIcon());

        community.setIconImage(iconImage);
    }

    @Transactional
    public CreateInvitationResponse createInvitation(Long userId, CreateInvitationRequest request) {
        Community community = communityRepository.findById(request.getId())
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_COMMUNITY));

        isAuthorizedMember(community, userId);

        // 이미 생성한 초대장 있는지 확인
        CommunityInvitation communityInvitation = community.getInvitations().stream()
                .filter(i -> i.isActivate())
                .filter(invitation -> invitation.getUserId().equals(userId))
                .findAny().orElse(null);

        // 없는 경우 생성
        if (Objects.isNull(communityInvitation)) {
            CommunityInvitation newInvitation = new CommunityInvitation();
            newInvitation.setCommunity(community);
            newInvitation.setUserId(userId);
            newInvitation.setActivate(true);
            communityInvitation = communityInvitationRepository.save(newInvitation);
            communityInvitation.setCode(base62.encode(communityInvitation.getId()));
        }

        return new CreateInvitationResponse(HOST_ADDRESS + COMMUNITY_INVITATION_PREFIX + communityInvitation.getCode());
    }

    public InvitationListResponse getInvitations(Long userId, Long communityId, String token) {

        Community community = communityRepository.findById(communityId)
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_COMMUNITY));

        isAuthorizedMember(community, userId);

        // 초대장을 생성한 멤버들의 아이디 조회
        List<Long> ids = community.getInvitations().stream()
                .filter(i -> i.isActivate())
                .map(invitation -> invitation.getUserId())
                .collect(Collectors.toList());
        
        // 아이디로 유저 정보 조회
        HashMap<Long, UserResponse> userInfoMap = getUserMap(ids, token);

        List<InvitationResponse> invitations = community.getInvitations().stream()
                .filter(i -> i.isActivate())
                .map(invitation -> new InvitationResponse(invitation, userInfoMap.get(invitation.getUserId())))
                .collect(Collectors.toList());

        return new InvitationListResponse(invitations);
    }

    private HashMap<Long, UserResponse> getUserMap(List<Long> ids, String token) {
        Set<Long> set = new HashSet<>(ids);
        ids = new ArrayList<>(set);

        // Todo auth 터졌을 때 예외 처리
        UserInfoListFeignResponse response = userClient.getUserInfoList(token, ids);
        return response.getResult();
    }

    @Transactional
    public void deleteInvitation(Long userId, Long invitationId) {

        CommunityInvitation invitation = communityInvitationRepository.findById(invitationId)
                .filter(i -> i.isActivate())
                .orElseThrow(() -> new CustomException(NON_VALID_INVITATION));

        isOwner(invitation.getCommunity(), userId);

        invitation.setActivate(false);
    }

    public MemberListResponse getMembers(Long userId, Long communityId, String token) {
        Community community = communityRepository.findById(communityId)
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_COMMUNITY));

        isAuthorizedMember(community, userId);

        // 커뮤니티에 속한 멤버의 아이디 조회
        List<Long> ids = community.getMembers().stream()
                .filter(m -> m.getStatus().equals(CommunityMemberStatus.NORMAL))
                .map(CommunityMember::getUserId)
                .collect(Collectors.toList());
        
        // 아이디로 유저 정보 조회
        HashMap<Long, UserResponse> userInfoMap = getUserMap(ids, token);

        List<MemberResponse> members = community.getMembers().stream()
                .filter(member -> member.getStatus().equals(CommunityMemberStatus.NORMAL))
                .map(member -> fromEntity(member, userInfoMap.get(member.getUserId())))
                .collect(Collectors.toList());

        return new MemberListResponse(members);
    }

    @Transactional
    public CommunityResponse join(Long userId, JoinRequest request, String token) {

        CommunityInvitation invitation = communityInvitationRepository.findByCode(request.getCode()).stream()
                .filter(i -> i.isActivate())
                .filter(i -> i.getCode().equals(request.getCode()))
                .findAny().orElseThrow(() -> new CustomException(NON_VALID_INVITATION));

        Community community = invitation.getCommunity();

        if (isSuspendedMember(community, userId))
            throw new CustomException(SUSPENDED_COMMUNITY);
        
        // 이미 커뮤니티에 속해있는지 확인
        isContains(community, userId);

        // 배치를 위해 첫 번재로 위치한 커뮤니티 조회
        CommunityMember firstNode = getFirstNode(userId);
        
        // 유저 정보 조회
        // Todo auth 터졌을 때 예외 처리
        // Todo feign config로 처리하기 controller, servive, userclient
        UserInfoFeignResponse userInfoFeignResponse = userClient.getUserInfo(token);
        String nickname = userInfoFeignResponse.getResult().getName();
        String profileImage = userInfoFeignResponse.getResult().getProfileImage();
        
        // 생성
        createCommunityMember(userId, community, nickname, profileImage, firstNode, CommunityRole.NONE);

        return CommunityResponse.fromEntity(community);
    }

    private void isContains(Community community, Long userId) {
        boolean isContains = community.getMembers().stream()
                .filter(cm -> cm.getStatus().equals(CommunityMemberStatus.NORMAL))
                .map(CommunityMember::getUserId)
                .collect(Collectors.toList())
                .contains(userId);
        if (isContains)
            throw new CustomException(ALREADY_INVITED);
    }

    private boolean isSuspendedMember(Community community, Long userId) {
        return community.getMembers().stream()
                .filter(member -> member.getStatus().equals(CommunityMemberStatus.SUSPENDED))
                .collect(Collectors.toList())
                .contains(userId);
    }

    @Transactional
    public void deleteMember(Long userId, Long communityId, Long memberId) {

        Community community = communityRepository.findById(communityId)
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_COMMUNITY));

        if (getOwnerUserId(community).equals(userId)) {
            CommunityMember otherMember = community.getMembers().stream()
                    .filter(cm -> !cm.getUserId().equals(memberId))
                    .findFirst().orElse(null);
            if (Objects.isNull(otherMember)) {
                community.delete();
                return;
            }
            otherMember.setRole(CommunityRole.OWNER);
        } else {
            if (userId != memberId)
                throw new CustomException(NON_AUTHORIZATION);
        }

        CommunityMember member = community.getMembers().stream()
                .filter(m -> m.getUserId().equals(memberId))
                .filter(m -> m.getStatus().equals(CommunityMemberStatus.NORMAL))
                .findAny().orElseThrow(() -> new CustomException(EMPTY_MEMBER));

        member.delete();
    }

    public void suspendMember(Long userId, Long communityId, Long memberId) {

        if (userId == memberId)
            throw new CustomException(CANT_SUSPEND_YOURSELF);

        Community community = communityRepository.findById(communityId)
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_COMMUNITY));

        isOwner(community, userId);

        CommunityMember member = community.getMembers().stream()
                .filter(m -> m.getUserId().equals(memberId))
                .filter(m -> m.getStatus().equals(CommunityMemberStatus.NORMAL))
                .findAny().orElseThrow(() -> new CustomException(EMPTY_MEMBER));

        member.suspend();
    }

    public CommunityDetailResponse getCommunityInfo(Long userId, Long communityId) {
        Community community = communityRepository.findById(communityId)
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_COMMUNITY));

        isAuthorizedMember(community, userId);

        return CommunityDetailResponse.fromEntity(community);
    }

    public MainResponse getCommunityList(Long userId, String token) {
        CommunityMember firstNode = getFirstNode(userId);

        // 소속 커뮤니티 조회
        List<Community> communities = new ArrayList<>();
        List<CommunityResponse> communityResponses;
        if (Objects.isNull(firstNode)) {
            communityResponses = communities.stream()
                    .map(CommunityResponse::fromEntity)
                    .collect(Collectors.toList());
        } else {
            communities.add(firstNode.getCommunity());
            CommunityMember nextNode = firstNode.getNextNode();
            while (!Objects.isNull(nextNode)) {
                communities.add(nextNode.getCommunity());
                nextNode = nextNode.getNextNode();
            }
            communityResponses = communities.stream()
                    .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                    .map(CommunityResponse::fromEntity)
                    .collect(Collectors.toList());
        }

        List<Room> rooms = roomMemberRepository.findByUserId(userId).stream()
                .filter(rm -> rm.getStatus().equals(CommonStatus.NORMAL))
                .map(RoomMember::getRoom)
                .collect(Collectors.toList());

        // auth service에 요청보낼 user id 리스트
        List<Long> ids = new ArrayList<>();
        rooms.forEach(room -> {
            // 1:1 메세지의 경우 상대방 user id 추출 후 리스트에 추가
            if (!room.getIsGroup()) {
                Long otherUserId = getOtherAccountIdInRoom(room, userId);
                ids.add(otherUserId);
            }
        });
        // 유저 정보 요청
        HashMap<Long, UserResponse> userMap = getUserMap(ids, token);

        List<Long> roomIds = rooms.stream().map(Room::getId).collect(Collectors.toList());
        List<UnreceivedMessageRoomResponse> roomResponses = new ArrayList<>();

        try {
            List<MessageCountResponse> sortedRoomsWithCount = chatClient.getMyMessages(new MessageCountRequest(userId, roomIds)).stream()
                    .filter(e -> e.getCount() > 0)
                    .collect(Collectors.toList());

            // 최신 메세지 순으로 DTO 생성
            HashMap<Long, Room> roomHashMap = new HashMap<>();
            for (Room room: rooms) {
                roomHashMap.put(room.getId(), room);
            }

            for (MessageCountResponse roomWithCount: sortedRoomsWithCount) {
                Room r = roomHashMap.get(roomWithCount.getRoomId());
                int count = roomWithCount.getCount();
                UnreceivedMessageRoomResponse unreceivedMessageRoomResponse = UnreceivedMessageRoomResponse.fromEntity(r, count);

                if (!r.getIsGroup()) {
                    Long otherUserId = r.getMembers().stream()
                            .filter(rm -> !rm.getUserId().equals(userId))
                            .map(RoomMember::getUserId)
                            .findAny().orElse(null);
                    UserResponse otherUser = userMap.get(otherUserId);
                    unreceivedMessageRoomResponse.setIcon(otherUser.getImage());
                }
                roomResponses.add(unreceivedMessageRoomResponse);
            }
        } catch (Exception e) {
            log.error("CHAT SERVER ERROR");
            e.printStackTrace();
        }

        return new MainResponse(roomResponses, communityResponses);
    }

    private Long getOtherAccountIdInRoom(Room room, Long userId) {
        return room.getMembers().stream()
                .filter(rm -> !rm.getUserId().equals(userId))
                .findAny().orElseThrow(() -> new CustomException(EMPTY_USER_IN_ROOM))
                .getUserId();
    }

    public CommunityMember getFirstNode(Long userId) {
        return communityMemberRepository.findByUserId(userId).stream()
                .filter(member -> Objects.isNull(member.getBeforeNode()) && member.getStatus().equals(CommunityMemberStatus.NORMAL))
                .findAny().orElse(null);
    }

    @Transactional
    public void locateCommunity(Long userId, LocateRequest request) {
        List<CommunityMember> communities = communityMemberRepository.findByUserId(userId).stream()
                .filter(cm -> cm.getStatus().equals(CommunityMemberStatus.NORMAL))
                .collect(Collectors.toList());

        CommunityMember target = communities.stream()
                .filter(cm -> cm.getCommunity().getId().equals(request.getId())
                    && cm.getCommunity().getStatus().equals(CommonStatus.NORMAL))
                .findAny().orElseThrow(() -> new CustomException(NON_VALID_COMMUNITY));

        CommunityMember tobe = null;
        if (!request.getNext().equals(0L)) {
            tobe = communities.stream()
                    .filter(cm -> cm.getCommunity().getId().equals(request.getNext())
                        && cm.getCommunity().getStatus().equals(CommonStatus.NORMAL))
                    .findAny().orElseThrow(() -> new CustomException(NON_VALID_NEXT_NODE));

            if (!Objects.isNull(tobe.getNextNode())) {
                if (tobe.getNextNode().equals(target))
                    throw new CustomException(ALREADY_LOCATED);
            }
        } else {
            if (Objects.isNull(target.getBeforeNode()))
                throw new CustomException(ALREADY_LOCATED);
        }

        target.locate(tobe, getFirstNode(userId));
    }

    @Transactional
    public void deleteCommunity(Long userId, Long communityId) {
        Community community = communityRepository.findById(communityId)
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_COMMUNITY));

        isOwner(community, userId);

        community.delete();
    }

    public MemberListFeignResponse getCommunityMember(Long communityId) {
        Community community = communityRepository.findById(communityId)
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_COMMUNITY));

        List<Long> ids = community.getMembers().stream()
                .filter(cm -> cm.getStatus().equals(CommunityMemberStatus.NORMAL))
                .map(CommunityMember::getUserId)
                .collect(Collectors.toList());

        return new MemberListFeignResponse(ids);
    }

    /**
     * /community/1
     * /direct/1
     */
    public List<String> getIncludeRoomList(Long userId) {
        List<String> communities = communityMemberRepository.findByUserId(userId).stream()
                .filter(cm -> cm.getStatus().equals(CommunityMemberStatus.NORMAL))
                .map(CommunityMember::getCommunity)
                .map(c -> COMMUNITY + c.getId())
                .collect(Collectors.toList());
        List<String> rooms = roomMemberRepository.findByUserId(userId).stream()
                .filter(rm -> rm.getStatus().equals(CommonStatus.NORMAL))
                .map(RoomMember::getRoom)
                .map(r -> DIRECT + r.getId())
                .collect(Collectors.toList());

        List<String> list = new ArrayList<>();
        list.addAll(communities);
        list.addAll(rooms);
        return list;
    }
}
