package com.example.communityserver.service;

import com.example.communityserver.client.UserClient;
import com.example.communityserver.domain.Category;
import com.example.communityserver.domain.Community;
import com.example.communityserver.domain.CommunityMember;
import com.example.communityserver.domain.type.ChannelType;
import com.example.communityserver.domain.type.CommunityRole;
import com.example.communityserver.dto.request.CreateCommunityRequest;
import com.example.communityserver.dto.request.EditCommunityIconRequest;
import com.example.communityserver.dto.request.EditCommunityNameRequest;
import com.example.communityserver.dto.response.CreateCommunityResponse;
import com.example.communityserver.dto.response.UserInfoFeignResponse;
import com.example.communityserver.exception.CustomException;
import com.example.communityserver.repository.CommunityRepository;
import com.example.communityserver.util.AmazonS3Connector;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.stream.Collectors;

import static com.example.communityserver.domain.Category.createCategory;
import static com.example.communityserver.domain.Channel.createChannel;
import static com.example.communityserver.domain.CommunityMember.createCommunityMember;
import static com.example.communityserver.exception.CustomExceptionStatus.EMPTY_COMMUNITY;
import static com.example.communityserver.exception.CustomExceptionStatus.NON_AUTHORIZATION;
import static com.example.communityserver.service.ChannelService.CHANNEL_DEFAULT_NAME;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CommunityService {

    private final CommunityRepository communityRepository;

    private final AmazonS3Connector amazonS3Connector;

    private final UserClient userClient;

    @Transactional
    public CreateCommunityResponse createCommunity(
            Long userId,
            CreateCommunityRequest request,
            String token
    ) {
        String iconImage = amazonS3Connector.uploadImage(userId, request.getIcon(), request.getThumbnail());

        Category textCategory = makeDefaultCategory(ChannelType.TEXT);
        Category voiceCategory = makeDefaultCategory(ChannelType.VOICE);

        Community newCommunity = Community.createCommunity(
                request.getName(), iconImage, request.isPublic(), textCategory, voiceCategory);

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

        String iconImage = amazonS3Connector.uploadImage(userId, request.getIcon(), request.getThumbnail());

        community.setIconImage(iconImage);
    }
}
