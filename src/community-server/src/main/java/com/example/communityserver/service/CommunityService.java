package com.example.communityserver.service;

import com.example.communityserver.client.UserClient;
import com.example.communityserver.domain.*;
import com.example.communityserver.domain.type.CommonStatus;
import com.example.communityserver.dto.response.*;
import com.example.communityserver.domain.type.ChannelType;
import com.example.communityserver.domain.type.CommunityRole;
import com.example.communityserver.dto.request.CreateCommunityRequest;
import com.example.communityserver.dto.request.CreateInvitationRequest;
import com.example.communityserver.dto.request.EditCommunityIconRequest;
import com.example.communityserver.dto.request.EditCommunityNameRequest;
import com.example.communityserver.exception.CustomException;
import com.example.communityserver.repository.ChannelRepository;
import com.example.communityserver.repository.CommunityInvitationRepository;
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
import static com.example.communityserver.exception.CustomExceptionStatus.*;
import static com.example.communityserver.service.ChannelService.CHANNEL_DEFAULT_NAME;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CommunityService {

    @Value("${smooth.url}")
    public String HOST_ADDRESS;

    private final CommunityRepository communityRepository;
    private final CommunityInvitationRepository communityInvitationRepository;
    private final ChannelRepository channelRepository;

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

        Category textCategory = makeDefaultCategory(ChannelType.TEXT);
        Category voiceCategory = makeDefaultCategory(ChannelType.VOICE);

        Community newCommunity = Community.createCommunity(
                request.getName(), iconImage, request.isPublic(), textCategory, voiceCategory);

        // Todo auth 터졌을 때 예외 처리
        // Todo feign config로 처리하기 controller, servive, userclient
        UserInfoFeignResponse userInfoFeignResponse = userClient.getUserInfo(token);
        String nickname = userInfoFeignResponse.getResult().getName();
        String profileImage = userInfoFeignResponse.getResult().getProfileImage();

        createCommunityMember(userId, newCommunity, nickname, profileImage, CommunityRole.OWNER);

        communityRepository.save(newCommunity);

        return CreateCommunityResponse.fromEntity(newCommunity);
    }

    private Category makeDefaultCategory(ChannelType channelType) {
        Category category = createCategory(channelType.getDescription(), true, null);
        createChannel(category, channelType, CHANNEL_DEFAULT_NAME, true, null);
        return category;
    }

    @Transactional
    public void editName(Long userId, EditCommunityNameRequest request) {

        Community community = communityRepository.findById(request.getCommunityId())
                .orElseThrow(() -> new CustomException(EMPTY_COMMUNITY));

        if (!isAuthorizedMember(community, userId))
            throw new CustomException(NON_AUTHORIZATION);

        community.setName(request.getName());
    }

    private boolean isAuthorizedMember(Community community, Long userId) {
        return community.getMembers().stream()
                .map(CommunityMember::getUserId).collect(Collectors.toList())
                .contains(userId);
    }

    @Transactional
    public void editIcon(Long userId, EditCommunityIconRequest request) {

        Community community = communityRepository.findById(request.getCommunityId())
                .orElseThrow(() -> new CustomException(EMPTY_COMMUNITY));

        if (!isAuthorizedMember(community, userId))
            throw new CustomException(NON_AUTHORIZATION);

        String iconImage = amazonS3Connector.uploadImage(userId, request.getIcon());

        community.setIconImage(iconImage);
    }

    @Transactional
    public CreateInvitationResponse createInvitation(Long userId, CreateInvitationRequest request) {

        Community community = communityRepository.findById(request.getCommunityId())
                .orElseThrow(() -> new CustomException(EMPTY_COMMUNITY));

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
                .orElseThrow(() -> new CustomException(EMPTY_COMMUNITY));

        if (!isAuthorizedMember(community, userId))
            throw new CustomException(NON_AUTHORIZATION);

        List<Long> ids = community.getInvitations().stream()
                .filter(i -> i.isActivate())
                .map(invitation -> invitation.getUserId())
                .collect(Collectors.toList());

        Set<Long> set = new HashSet<>(ids);
        ids = new ArrayList<>(set);

        // Todo auth 터졌을 때 예외 처리
        UserInfoListFeignResponse response = userClient.getUserInfoList(token, ids);
        HashMap<Long, UserInfoListFeignResponse.UserInfoListResponse> userInfoMap = response.getResult();

        List<InvitationResponse> invitations = community.getInvitations().stream()
                .filter(i -> i.isActivate())
                .map(invitation ->
                        new InvitationResponse(invitation, userInfoMap.get(invitation.getUserId())))
                .collect(Collectors.toList());

        return new InvitationListResponse(invitations);
    }

    @Transactional
    public void deleteInvitation(Long userId, Long invitationId) {

        CommunityInvitation invitation = communityInvitationRepository.findById(invitationId)
                .orElseThrow(() -> new CustomException(EMPTY_INVITATION));

        if (!isAuthorizedMember(invitation.getCommunity(), userId))
            throw new CustomException(NON_AUTHORIZATION);

        if (!invitation.isActivate())
            throw new CustomException(NON_VALID_INVITATION);

        invitation.setActivate(false);
    }
}
