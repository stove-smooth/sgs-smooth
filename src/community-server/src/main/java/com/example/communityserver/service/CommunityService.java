package com.example.communityserver.service;

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
import com.example.communityserver.util.AmazonS3Connector;
import com.example.communityserver.util.Base62;
import lombok.RequiredArgsConstructor;
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

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CommunityService {

    @Value("${smooth.url}")
    public String HOST_ADDRESS;

    private final CommunityRepository communityRepository;
    private final CommunityMemberRepository communityMemberRepository;
    private final CommunityInvitationRepository communityInvitationRepository;

    private final AmazonS3Connector amazonS3Connector;
    private final Base62 base62;

    private final UserClient userClient;

    @Transactional
    public CreateCommunityResponse createCommunity(
            Long userId,
            CreateCommunityRequest request,
            String token
    ) {
        String iconImage = amazonS3Connector.uploadImage(userId, request.getIcon());

        Category voiceCategory = makeDefaultCategory(ChannelType.VOICE, null);
        Category textCategory = makeDefaultCategory(ChannelType.TEXT, voiceCategory);

        Community newCommunity = Community.createCommunity(
                request.getName(), iconImage, request.isPublic(), textCategory, voiceCategory);

        // Todo auth 터졌을 때 예외 처리
        // Todo feign config로 처리하기 controller, servive, userclient
        UserInfoFeignResponse userInfoFeignResponse = userClient.getUserInfo(token);
        String nickname = userInfoFeignResponse.getResult().getName();
        String profileImage = userInfoFeignResponse.getResult().getProfileImage();

        CommunityMember firstNode = getFirstNode(userId);

        createCommunityMember(userId, newCommunity, nickname, profileImage, firstNode, CommunityRole.OWNER);

        communityRepository.save(newCommunity);

        return CreateCommunityResponse.fromEntity(newCommunity);
    }

    private Category makeDefaultCategory(ChannelType channelType, Category nextNode) {
        Category category = createCategory(channelType.getDescription(), true, nextNode, null);
        createChannel(category, channelType, CHANNEL_DEFAULT_NAME, true, null, null);
        return category;
    }

    @Transactional
    public void editName(Long userId, EditCommunityNameRequest request) {

        Community community = communityRepository.findById(request.getCommunityId())
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_COMMUNITY));

        if (!isOwner(community, userId))
            throw new CustomException(NON_AUTHORIZATION);

        community.setName(request.getName());
    }

    private boolean isAuthorizedMember(Community community, Long userId) {
        return community.getMembers().stream()
                .filter(communityMember -> communityMember.getStatus().equals(CommunityMemberStatus.NORMAL))
                .map(CommunityMember::getUserId)
                .collect(Collectors.toList())
                .contains(userId);
    }

    private boolean isOwner(Community community, Long userId) {
        return community.getMembers().stream()
                .filter(communityMember -> communityMember.getRole().equals(CommunityRole.OWNER))
                .collect(Collectors.toList())
                .contains(userId);
    }

    @Transactional
    public void editIcon(Long userId, EditCommunityIconRequest request) {

        Community community = communityRepository.findById(request.getCommunityId())
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_COMMUNITY));

        if (!isOwner(community, userId))
            throw new CustomException(NON_AUTHORIZATION);

        String iconImage = amazonS3Connector.uploadImage(userId, request.getIcon());

        community.setIconImage(iconImage);
    }

    @Transactional
    public CreateInvitationResponse createInvitation(Long userId, CreateInvitationRequest request) {

        Community community = communityRepository.findById(request.getCommunityId())
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_COMMUNITY));

        if (!isAuthorizedMember(community, userId))
            throw new CustomException(NON_AUTHORIZATION);

        CommunityInvitation communityInvitation = community.getInvitations().stream()
                .filter(i -> i.isActivate())
                .filter(invitation -> invitation.getUserId().equals(userId))
                .findAny().orElse(null);

        if (Objects.isNull(communityInvitation)) {
            CommunityInvitation newInvitation = new CommunityInvitation();
            newInvitation.setCommunity(community);
            newInvitation.setUserId(userId);
            newInvitation.setActivate(true);
            communityInvitation = communityInvitationRepository.save(newInvitation);
            communityInvitation.setCode(base62.encode(communityInvitation.getId()));
        }

        return new CreateInvitationResponse(HOST_ADDRESS + "/" + communityInvitation.getCode());
    }

    public InvitationListResponse getInvitations(Long userId, Long communityId, String token) {

        Community community = communityRepository.findById(communityId)
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_COMMUNITY));

        if (!isAuthorizedMember(community, userId))
            throw new CustomException(NON_AUTHORIZATION);

        HashMap<Long, UserResponse> userInfoMap = getUserMap(community, token);

        List<InvitationResponse> invitations = community.getInvitations().stream()
                .filter(i -> i.isActivate())
                .map(invitation ->
                        new InvitationResponse(invitation, userInfoMap.get(invitation.getUserId())))
                .collect(Collectors.toList());

        return new InvitationListResponse(invitations);
    }

    private HashMap<Long, UserResponse> getUserMap(Community community, String token) {
        List<Long> ids = community.getInvitations().stream()
                .filter(i -> i.isActivate())
                .map(invitation -> invitation.getUserId())
                .collect(Collectors.toList());

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

        if (!isAuthorizedMember(invitation.getCommunity(), userId))
            throw new CustomException(NON_AUTHORIZATION);

        invitation.setActivate(false);
    }

    public MemberListResponse getMembers(Long userId, Long communityId, String token) {

        Community community = communityRepository.findById(communityId)
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_COMMUNITY));

        if (!isAuthorizedMember(community, userId))
            throw new CustomException(NON_AUTHORIZATION);

        HashMap<Long, UserResponse> userInfoMap = getUserMap(community, token);

        List<MemberResponse> members = community.getMembers().stream()
                .filter(member -> member.getStatus().equals(CommunityMemberStatus.NORMAL))
                .map(member -> fromEntity(member, userInfoMap.get(member.getUserId())))
                .collect(Collectors.toList());

        return new MemberListResponse(members);
    }

    @Transactional
    public void join(Long userId, JoinCommunityRequest request, String token) {

        CommunityInvitation invitation = communityInvitationRepository.findByCode(request.getCode())
                .filter(i -> i.isActivate())
                .orElseThrow(() -> new CustomException(NON_VALID_INVITATION));

        Community community = invitation.getCommunity();

        if (isSuspendedMember(community, userId))
            throw new CustomException(SUSPENDED_COMMUNITY);

        if (!isAuthorizedMember(community, userId)) {
            CommunityMember firstNode = getFirstNode(userId);
            // Todo auth 터졌을 때 예외 처리
            // Todo feign config로 처리하기 controller, servive, userclient
            UserInfoFeignResponse userInfoFeignResponse = userClient.getUserInfo(token);
            String nickname = userInfoFeignResponse.getResult().getName();
            String profileImage = userInfoFeignResponse.getResult().getProfileImage();
            createCommunityMember(userId, community, nickname, profileImage, firstNode, CommunityRole.NONE);
        }
    }

    private boolean isSuspendedMember(Community community, Long userId) {
        return community.getMembers().stream()
                .filter(member -> member.getStatus().equals(CommunityMemberStatus.SUSPENDED))
                .collect(Collectors.toList())
                .contains(userId);
    }

    @Transactional
    public void deleteMember(Long userId, Long communityId, Long memberId) {
        CommunityMember member = getMember(userId, communityId, memberId);
        member.setStatus(CommunityMemberStatus.DELETED);
    }

    private CommunityMember getMember(Long userId, Long communityId, Long memberId) {
        Community community = communityRepository.findById(communityId)
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_COMMUNITY));

        if (!isOwner(community, userId))
            throw new CustomException(NON_AUTHORIZATION);

        return community.getMembers().stream()
                .filter(member -> member.getUserId().equals(memberId))
                .filter(member -> member.getStatus().equals(CommunityMemberStatus.NORMAL))
                .findAny().orElseThrow(() -> new CustomException(EMPTY_MEMBER));
    }

    public void suspendMember(Long userId, Long communityId, Long memberId) {
        CommunityMember member = getMember(userId, communityId, memberId);
        member.setStatus(CommunityMemberStatus.SUSPENDED);
    }

    public CommunityDetailResponse getCommunity(Long userId, Long communityId) {
        Community community = communityRepository.findById(communityId)
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_COMMUNITY));

        if (!isAuthorizedMember(community, userId))
            throw new CustomException(NON_AUTHORIZATION);

        return CommunityDetailResponse.fromEntity(community);
    }

    public CommunityListResponse getCommunityList(Long userId) {
        CommunityMember firstNode = getFirstNode(userId);

        List<CommunityResponse> list = new ArrayList<>();
        if (Objects.isNull(firstNode))
            return new CommunityListResponse(list);

        list.add(CommunityResponse.fromEntity(firstNode.getCommunity()));
        CommunityMember nextNode = firstNode.getNextNode();
        while (!Objects.isNull(nextNode)) {
            list.add(CommunityResponse.fromEntity(nextNode.getCommunity()));
            nextNode = nextNode.getNextNode();
        }
        return new CommunityListResponse(list);
    }

    public CommunityMember getFirstNode(Long userId) {
        return communityMemberRepository.findByUserId(userId).stream()
                .filter(member -> member.isFirstNode())
                .findAny().orElse(null);
    }

    @Transactional
    public void locateCommunity(Long userId, LocateCommunityRequest request) {
        List<CommunityMember> communities = communityMemberRepository.findByUserId(userId).stream()
                .filter(cm -> cm.getStatus().equals(CommunityMemberStatus.NORMAL))
                .collect(Collectors.toList());

        CommunityMember target = communities.stream()
                .filter(cm -> cm.getCommunity().getId().equals(request.getCommunityId()))
                .findAny().orElseThrow(() -> new CustomException(NON_VALID_COMMUNITY));

        CommunityMember before;
        if (request.getNextNode().equals(0L))
            before = null;
        else {
            before = communities.stream()
                    .filter(cm -> cm.getCommunity().getId().equals(request.getNextNode()))
                    .findAny().orElseThrow(() -> new CustomException(NON_VALID_COMMUNITY));

            System.out.println(before.getNextNode());

            if (!Objects.isNull(before.getNextNode())) {
                if (before.getNextNode().equals(target))
                    throw new CustomException(ALREADY_LOCATED_COMMUNITY);
            }
        }

        CommunityMember first = getFirstNode(userId);

        target.locate(before, first);
    }

    @Transactional
    public void deleteCommunity(Long userId, Long communityId) {
        Community community = communityRepository.findById(communityId)
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_COMMUNITY));

        if (!isOwner(community, userId))
            throw new CustomException(NON_AUTHORIZATION);

        community.setStatus(CommonStatus.DELETED);
    }
}
