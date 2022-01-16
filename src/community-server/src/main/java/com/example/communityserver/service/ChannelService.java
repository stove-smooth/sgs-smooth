package com.example.communityserver.service;

import com.example.communityserver.domain.*;
import com.example.communityserver.domain.type.ChannelStatus;
import com.example.communityserver.domain.type.CommonStatus;
import com.example.communityserver.domain.type.CommunityMemberStatus;
import com.example.communityserver.domain.type.CommunityRole;
import com.example.communityserver.dto.request.CreateChannelRequest;
import com.example.communityserver.dto.request.EditDescRequest;
import com.example.communityserver.dto.request.EditNameRequest;
import com.example.communityserver.dto.response.ChannelResponse;
import com.example.communityserver.exception.CustomException;
import com.example.communityserver.repository.CategoryRepository;
import com.example.communityserver.repository.ChannelRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

import static com.example.communityserver.exception.CustomExceptionStatus.*;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ChannelService {

    private final CategoryRepository categoryRepository;
    private final ChannelRepository channelRepository;

    public static final String CHANNEL_DEFAULT_NAME = "일반";

    @Transactional
    public ChannelResponse createChannel(Long userId, CreateChannelRequest request) {

        Category category = categoryRepository.findById(request.getCategoryId())
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_CATEGORY));

        Community community = category.getCommunity();
        if (!community.getStatus().equals(CommonStatus.NORMAL))
            throw new CustomException(NON_VALID_COMMUNITY);

        isAuthorizedMember(community, userId);

        if (!category.isPublic() && request.isPublic())
            throw new CustomException(ALREADY_PUBLIC_STATE);

        Channel firstChannel = getFirstChannel(category);

        List<ChannelMember> members = new ArrayList<>();

        if (!request.isPublic()) {
            validateMemberId(category, request.getMembers());
            if (!Objects.isNull(request.getMembers())) {
                members = request.getMembers().stream()
                        .map(ChannelMember::new)
                        .collect(Collectors.toList());
            }
            members.add(new ChannelMember(userId));
        }

        Channel newChannel = Channel.createChannel(
                category,
                request.getChannelType(),
                request.getName(),
                request.isPublic(),
                firstChannel,
                members
        );

        channelRepository.save(newChannel);

        return ChannelResponse.fromEntity(newChannel);
    }

    private Channel getFirstChannel(Category category) {
        return category.getChannels().stream()
                .filter(c -> c.isFirstNode() && c.getStatus().equals(ChannelStatus.NORMAL))
                .findFirst().orElse(null);
    }

    private void validateMemberId(Category category, List<Long> members) {
        if (!Objects.isNull(members)) {
            List<Long> categoryMemberUserIds = category.getMembers().stream()
                    .filter(categoryMember -> categoryMember.isStatus())
                    .map(CategoryMember::getUserId)
                    .collect(Collectors.toList());

            for (Long memberId: members) {
                if (!categoryMemberUserIds.contains(memberId))
                    throw new CustomException(NON_VALID_USER_ID_IN_COMMUNITY);
            }
        }
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

    @Transactional
    public void editName(Long userId, EditNameRequest request) {

        Channel channel = channelRepository.findById(request.getId())
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_CHANNEL));

        isAuthorizedMember(channel.getCategory().getCommunity(), userId);

        channel.setName(request.getName());
    }

    @Transactional
    public void editDescription(Long userId, EditDescRequest request) {

        Channel channel = channelRepository.findById(request.getId())
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_CHANNEL));

        isAuthorizedMember(channel.getCategory().getCommunity(), userId);

        channel.setDescription(request.getDescription());
    }

    @Transactional
    public void deleteChannel(Long userId, Long channelId) {

        Channel channel = channelRepository.findById(channelId)
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_CHANNEL));

        isOwner(channel.getCategory().getCommunity(), userId);

        channel.delete();
    }

    private void isOwner(Community community, Long userId) {
        Long ownerUserId = community.getMembers().stream()
                .filter(cm -> cm.getRole().equals(CommunityRole.OWNER))
                .findFirst().orElseThrow(() -> new CustomException(NON_EXIST_OWNER))
                .getUserId();

        if (!ownerUserId.equals(userId))
            throw new CustomException(NON_AUTHORIZATION);
    }
}
