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
    public void editIcon(Long userId, EditCommunityIconRequest request) {

        Community community = communityRepository.findById(request.getCommunityId())
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_COMMUNITY));

        isOwner(community, userId);

        String iconImage = amazonS3Connector.uploadImage(userId, request.getIcon());

        community.setIconImage(iconImage);
    }

    @Transactional
    public CreateInvitationResponse createInvitation(Long userId, CreateInvitationRequest request) {

        Community community = communityRepository.findById(request.getCommunityId())
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_COMMUNITY));

        isAuthorizedMember(community, userId);
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

        isAuthorizedMember(community, userId);
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

        isOwner(invitation.getCommunity(), userId);

        invitation.setActivate(false);
    }

    public MemberListResponse getMembers(Long userId, Long communityId, String token) {

        Community community = communityRepository.findById(communityId)
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_COMMUNITY));

        isAuthorizedMember(community, userId);
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

        isAuthorizedMember(community, userId);
        isContains(community, userId);

        CommunityMember firstNode = getFirstNode(userId);
        // Todo auth 터졌을 때 예외 처리
        // Todo feign config로 처리하기 controller, servive, userclient
        UserInfoFeignResponse userInfoFeignResponse = userClient.getUserInfo(token);
        String nickname = userInfoFeignResponse.getResult().getName();
        String profileImage = userInfoFeignResponse.getResult().getProfileImage();
        createCommunityMember(userId, community, nickname, profileImage, firstNode, CommunityRole.NONE);
    }

    private void isContains(Community community, Long userId) {
        boolean isContains = community.getMembers().stream()
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

    public CommunityListResponse getCommunityList(Long userId) {
        CommunityMember firstNode = getFirstNode(userId);

        List<Community> communities = new ArrayList<>();
        if (Objects.isNull(firstNode))
            return new CommunityListResponse(
                    communities.stream()
                            .map(CommunityResponse::fromEntity)
                            .collect(Collectors.toList())
            );

        communities.add(firstNode.getCommunity());
        CommunityMember nextNode = firstNode.getNextNode();
        while (!Objects.isNull(nextNode)) {
            communities.add(nextNode.getCommunity());
            nextNode = nextNode.getNextNode();
        }

        List<CommunityResponse> responses = communities.stream()
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .map(CommunityResponse::fromEntity)
                .collect(Collectors.toList());

        return new CommunityListResponse(responses);
    }

    public CommunityMember getFirstNode(Long userId) {
        return communityMemberRepository.findByUserId(userId).stream()
                .filter(member -> member.isFirstNode() && member.getStatus().equals(CommunityMemberStatus.NORMAL))
                .findAny().orElse(null);
    }

    @Transactional
    public void locateCommunity(Long userId, LocateRequest request) {
        List<CommunityMember> communities = communityMemberRepository.findByUserId(userId).stream()
                .filter(cm -> cm.getStatus().equals(CommunityMemberStatus.NORMAL))
                .collect(Collectors.toList());

        CommunityMember target = communities.stream()
                .filter(cm -> cm.getCommunity().getId().equals(request.getId()))
                .findAny().orElseThrow(() -> new CustomException(NON_VALID_COMMUNITY));

        CommunityMember first = getFirstNode(userId);

        CommunityMember before = null;
        if (request.getNext().equals(0L)) {
            if (target.equals(first))
                throw new CustomException(ALREADY_LOCATED);
        } else {
            before = communities.stream()
                    .filter(cm -> cm.getCommunity().getId().equals(request.getNext()))
                    .filter(cm -> cm.getStatus().equals(CommunityMemberStatus.NORMAL))
                    .findAny().orElseThrow(() -> new CustomException(NON_VALID_NEXT_NODE));

            if (!Objects.isNull(before.getNextNode())) {
                if (before.getNextNode().equals(target))
                    throw new CustomException(ALREADY_LOCATED);
            }
        }

        target.locate(before, first);
    }

    @Transactional
    public void deleteCommunity(Long userId, Long communityId) {
        Community community = communityRepository.findById(communityId)
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_COMMUNITY));

        isOwner(community, userId);

        community.delete();
    }
}
