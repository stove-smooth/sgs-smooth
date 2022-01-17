package com.example.communityserver.service;

import com.example.communityserver.domain.*;
import com.example.communityserver.domain.type.ChannelStatus;
import com.example.communityserver.domain.type.CommonStatus;
import com.example.communityserver.domain.type.CommunityMemberStatus;
import com.example.communityserver.domain.type.CommunityRole;
import com.example.communityserver.dto.request.*;
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

        isOwner(channel, userId);

        channel.delete();
    }

    private void isOwner(Channel channel, Long userId) {
        Long ownerUserId = channel.getCategory().getCommunity().getMembers().stream()
                .filter(cm -> cm.getRole().equals(CommunityRole.OWNER))
                .findFirst().orElseThrow(() -> new CustomException(NON_EXIST_OWNER))
                .getUserId();

        if (!ownerUserId.equals(userId))
            throw new CustomException(NON_AUTHORIZATION);
    }

    public void inviteMember(Long userId, InviteMemberRequest request) {

        Channel channel = channelRepository.findById(request.getId())
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_CHANNEL));

        Community community = channel.getCategory().getCommunity();

        isAuthorizedMember(community, userId);

        if (channel.isPublic())
            throw new CustomException(ALREADY_PUBLIC_STATE);

        for (Long memberId: request.getMembers()) {
            isMemberInCommunity(community, memberId);
            isContains(channel, memberId);
            channel.addMember(new ChannelMember(memberId));
        }
    }

    private void isContains(Channel channel, Long memberId) {
        boolean isContains = channel.getMembers().stream()
                .filter(member -> member.isStatus())
                .map(ChannelMember::getUserId)
                .collect(Collectors.toList())
                .contains(memberId);
        if (isContains)
            throw new CustomException(ALREADY_INVITED);
    }

    private void isMemberInCommunity(Community community, Long memberId) {
        boolean isMember = community.getMembers().stream()
                .filter(member -> member.getStatus().equals(CommunityMemberStatus.NORMAL))
                .map(CommunityMember::getUserId)
                .collect(Collectors.toList())
                .contains(memberId);
        if (!isMember)
            throw new CustomException(NON_VALID_USER_ID_IN_COMMUNITY);
    }

    @Transactional
    public void deleteMember(Long userId, Long channelId, Long memberId) {

        Channel channel = channelRepository.findById(channelId)
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_CHANNEL));

        if (channel.isPublic())
            throw new CustomException(ALREADY_PUBLIC_STATE);

        if (!userId.equals(memberId))
            isOwner(channel, userId);

        ChannelMember member = channel.getMembers().stream()
                .filter(m -> m.getUserId().equals(memberId))
                .filter(m -> m.isStatus())
                .findAny().orElseThrow(() -> new CustomException(EMPTY_MEMBER));

        member.delete();
    }

    @Transactional
    public ChannelResponse copy(Long userId, CopyChannelRequest request) {

        Channel channel = channelRepository.findById(request.getId())
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_CHANNEL));

        isAuthorizedMember(channel.getCategory().getCommunity(), userId);

        Channel firstChannel = getFirstChannel(channel.getCategory());

        List<ChannelMember> members = new ArrayList<>();
        if (!channel.isPublic()) {
            members = channel.getMembers().stream()
                    .map(ChannelMember::getUserId)
                    .map(ChannelMember::new)
                    .collect(Collectors.toList());
        }

        Channel newChannel = Channel.createChannel(
                channel.getCategory(),
                channel.getType(),
                request.getName(),
                channel.isPublic(),
                firstChannel,
                members
        );
        channelRepository.save(newChannel);

        return ChannelResponse.fromEntity(newChannel);
    }

    @Transactional
    public void locateChannel(Long userId, LocateRequest request) {

        Channel target = channelRepository.findById(request.getId())
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_CHANNEL));

        Category category = target.getCategory();
        isAuthorizedMember(category.getCommunity(), userId);

        List<Channel> channels = category.getChannels().stream()
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .collect(Collectors.toList());

        Channel first = getFirstChannel(category);

        Channel before = null;
        if (request.getNext().equals(0L)) {
            if (target.equals(first))
                throw new CustomException(ALREADY_LOCATED);
        } else {
            before = channels.stream()
                    .filter(c -> c.getId().equals(request.getNext()))
                    .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                    .findAny().orElseThrow(() -> new CustomException(NON_VALID_NEXT_NODE));

            if (!Objects.isNull(before.getNextNode())) {
                if (before.getNextNode().equals(target))
                    throw new CustomException(ALREADY_LOCATED);
            }
        }

        target.locate(before, first);
    }
}
