package com.example.communityserver.service;

import com.example.communityserver.domain.Category;
import com.example.communityserver.domain.Community;
import com.example.communityserver.domain.type.ChannelType;
import com.example.communityserver.domain.type.CommunityRole;
import com.example.communityserver.dto.request.CreateCommunityRequest;
import com.example.communityserver.dto.response.CreateCommunityResponse;
import com.example.communityserver.repository.CommunityRepository;
import com.example.communityserver.util.AmazonS3Connector;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import static com.example.communityserver.domain.Category.createCategory;
import static com.example.communityserver.domain.Channel.createChannel;
import static com.example.communityserver.domain.CommunityMember.createCommunityMember;
import static com.example.communityserver.service.ChannelService.CHANNEL_DEFAULT_NAME;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CommunityService {

    private final CommunityRepository communityRepository;

    private final AmazonS3Connector amazonS3Connector;

    @Transactional
    public CreateCommunityResponse createCommunity(
            Long userId,
            CreateCommunityRequest request
    ) {
        // String iconImage = amazonS3Connector.uploadImage(userId, request.getIcon(), request.getThumbnail());
        String iconImage = "a";

        Category textCategory = makeDefaultCategory(ChannelType.TEXT);
        Category voiceCategory = makeDefaultCategory(ChannelType.VOICE);

        Community newCommunity = Community.createCommunity(
                request.getName(), iconImage, request.isPublic(), textCategory, voiceCategory);

        // Todo 사용자 정보 불러오기 - user service
        String nickname = "김희동";
        String profileImage = "프로필이미지";

        createCommunityMember(userId, newCommunity, nickname, profileImage, CommunityRole.OWNER);

        communityRepository.save(newCommunity);

        return CreateCommunityResponse.fromEntity(newCommunity);
    }

    private Category makeDefaultCategory(ChannelType channelType) {
        Category category = createCategory(channelType.getDescription(), true, null);
        createChannel(category, channelType, CHANNEL_DEFAULT_NAME, true, null);
        return category;
    }
}
