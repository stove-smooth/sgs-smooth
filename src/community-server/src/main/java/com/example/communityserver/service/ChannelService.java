package com.example.communityserver.service;

import com.example.communityserver.client.UserClient;
import com.example.communityserver.domain.*;
import com.example.communityserver.domain.type.*;
import com.example.communityserver.dto.request.*;
import com.example.communityserver.dto.response.*;
import com.example.communityserver.exception.CustomException;
import com.example.communityserver.repository.CategoryRepository;
import com.example.communityserver.repository.ChannelRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.SetOperations;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

import static com.example.communityserver.dto.response.MemberResponse.fromEntity;
import static com.example.communityserver.exception.CustomExceptionStatus.*;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ChannelService {

    private final RedisTemplate redisTemplate;

    private final CategoryRepository categoryRepository;
    private final ChannelRepository channelRepository;

    public static final String CHANNEL_DEFAULT_NAME = "일반";

    private final UserClient userClient;

    public ChannelDetailResponse getChannelDetail(Long userId, Long channelId, String token) {
        Channel channel = channelRepository.findById(channelId)
                .filter(c -> c.getStatus().equals(ChannelStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_CHANNEL));

        Community community = !Objects.isNull(channel.getCategory()) ?
                channel.getCategory().getCommunity() :
                channel.getParent().getCategory().getCommunity();
        isAuthorizedMember(community, userId);

        ChannelDetailResponse response = ChannelDetailResponse.fromEntity(channel);

        List<Long> ids = null;
        if (channel.isPublic()) {
            ids = community.getMembers().stream()
                    .filter(m -> m.getStatus().equals(CommunityMemberStatus.NORMAL))
                    .map(m -> m.getUserId())
                    .collect(Collectors.toList());
        } else {
            ids = channel.getMembers().stream()
                    .filter(m -> m.isStatus())
                    .map(m -> m.getUserId())
                    .collect(Collectors.toList());
        }
        HashMap<Long, UserResponse> userMap = getUserMap(ids, token);

        response.setMembers(ChannelDetailResponse.fromMember(community, ids, userMap));

        return response;
    }

    private HashMap<Long, UserResponse> getUserMap(List<Long> ids, String token) {
        Set<Long> set = new HashSet<>(ids);
        ids = new ArrayList<>(set);

        // Todo auth 터졌을 때 예외 처리
        UserInfoListFeignResponse response = userClient.getUserInfoList(token, ids);
        return response.getResult();
    }

    @Transactional
    public ChannelResponse createChannel(Long userId, CreateChannelRequest request) {
        Category category = categoryRepository.findById(request.getId())
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
                request.getType(),
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
                .filter(c -> Objects.isNull(c.getBeforeNode()) && c.getStatus().equals(ChannelStatus.NORMAL))
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
    public ChannelResponse createThread(Long userId, CreateThreadRequest request, String token) {
        Channel channel = channelRepository.findById(request.getChannelId())
                .filter(c -> c.getStatus().equals(ChannelStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_CHANNEL));

        Community community = channel.getCategory().getCommunity();
        isAuthorizedMember(community, userId);

        UserInfoFeignResponse userInfoFeignResponse = userClient.getUserInfo(token);
        String nickname = userInfoFeignResponse.getResult().getName();

        List<ChannelMember> members = new ArrayList<>();
        if (!channel.isPublic()) {
            members = channel.getMembers().stream()
                    .map(ChannelMember::getUserId)
                    .map(ChannelMember::new)
                    .collect(Collectors.toList());
        }

        Channel newThread = Channel.createThread(
                nickname,
                request.getMessageId(),
                channel,
                request.getName(),
                members
        );
        channelRepository.save(newThread);

        return ChannelResponse.fromEntity(newThread);
    }

    @Transactional
    public void editName(Long userId, EditNameRequest request) {

        Channel channel = channelRepository.findById(request.getId())
                .filter(c -> c.getStatus().equals(ChannelStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_CHANNEL));

        Community community = !Objects.isNull(channel.getCategory()) ?
                channel.getCategory().getCommunity() :
                channel.getParent().getCategory().getCommunity();
        isAuthorizedMember(community, userId);

        channel.setName(request.getName());
    }

    @Transactional
    public void editDescription(Long userId, EditDescRequest request) {

        Channel channel = channelRepository.findById(request.getId())
                .filter(c -> c.getStatus().equals(ChannelStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_CHANNEL));

        Community community = !Objects.isNull(channel.getCategory()) ?
                channel.getCategory().getCommunity() :
                channel.getParent().getCategory().getCommunity();
        isAuthorizedMember(community, userId);

        channel.setDescription(request.getDescription());
    }

    @Transactional
    public void deleteChannel(Long userId, Long channelId) {

        Channel channel = channelRepository.findById(channelId)
                .filter(c -> c.getStatus().equals(ChannelStatus.NORMAL))
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
                .filter(c -> c.getStatus().equals(ChannelStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_CHANNEL));

        if (!Objects.isNull(channel.getParent()))
            throw new CustomException(NON_SERVE_IN_THREAD);

        Community community = channel.getCategory().getCommunity();
        isAuthorizedMember(community, userId);

        if (channel.isPublic())
            throw new CustomException(ALREADY_PUBLIC_STATE);

        for (Long memberId: request.getMembers()) {
            isMemberInCommunity(community, memberId);
            if (isContains(channel, memberId))
                throw new CustomException(ALREADY_INVITED);
            channel.addMember(new ChannelMember(memberId));
        }
    }

    private boolean isContains(Channel channel, Long memberId) {
        return channel.getMembers().stream()
                .filter(member -> member.isStatus())
                .map(ChannelMember::getUserId)
                .collect(Collectors.toList())
                .contains(memberId);
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
                .filter(c -> c.getStatus().equals(ChannelStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_CHANNEL));

        if (!Objects.isNull(channel.getParent()))
            throw new CustomException(NON_SERVE_IN_THREAD);

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
                .filter(c -> c.getStatus().equals(ChannelStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_CHANNEL));

        if (!Objects.isNull(channel.getParent()))
            throw new CustomException(NON_SERVE_IN_THREAD);

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
    public void locateChannel(Long userId, LocateChannelRequest request) {
        Channel target = channelRepository.findById(request.getId())
                .filter(c -> c.getStatus().equals(ChannelStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_CHANNEL));

        Category category = categoryRepository.findById(request.getCategoryId())
                .filter(c -> c.getStatus().equals(ChannelStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_CATEGORY));

        if (!Objects.isNull(target.getParent()))
            throw new CustomException(NON_SERVE_IN_THREAD);

        isAuthorizedMember(category.getCommunity(), userId);

        List<Channel> channels = category.getChannels().stream()
                .filter(c -> c.getStatus().equals(ChannelStatus.NORMAL))
                .collect(Collectors.toList());

        Channel tobe = null;
        if (!request.getNext().equals(0L)) {
            tobe = channels.stream()
                    .filter(c -> c.getId().equals(request.getNext())
                        && c.getStatus().equals(ChannelStatus.NORMAL))
                    .findAny().orElseThrow(() -> new CustomException(NON_VALID_NEXT_NODE));

            if (!Objects.isNull(tobe.getNextNode())) {
                if (tobe.getNextNode().equals(target))
                    throw new CustomException(ALREADY_LOCATED);
            }
        }

        Channel first = getFirstChannel(category);

        if (target.getCategory().equals(category)) {
            // 동일한 카테고리 내 이동
            if (Objects.isNull(target.getBeforeNode())) {
                // target이 첫 번째 노드일 때
                target.getNextNode().setBeforeNode(null);
                target.setNextNode(tobe.getNextNode());
                tobe.setNextNode(target);
            } else {
                // target이 첫 번째 노드가 아닐 때
                target.getBeforeNode().setNextNode(target.getNextNode());
                if (Objects.isNull(tobe)) {
                    // 첫 번째 노드로 변경하는 경우
                    target.setBeforeNode(null);
                    target.setNextNode(first);
                } else {
                    target.setNextNode(tobe.getNextNode());
                    tobe.setNextNode(target);
                }
            }
        } else {
            // 다른 카테고리로 이동
            target.setCategory(category);
            if (Objects.isNull(target.getBeforeNode())) {
                // target이 첫 번째 노드일 때
                if (!Objects.isNull(target.getNextNode()))
                    target.getNextNode().setBeforeNode(null);

                if (Objects.isNull(tobe)) {
                    // 다른 카테고리의 첫 번째 노드로 변경하는 경우
                    target.setNextNode(first);
                } else {
                    target.setNextNode(tobe.getNextNode());
                    tobe.setNextNode(target);
                }
            } else {
                // target이 첫 번째 노드가 아닐 때
                target.getBeforeNode().setNextNode(target.getNextNode());
                if (Objects.isNull(tobe)) {
                    // 다른 카테고리의 첫 번째 노드로 변경하는 경우
                    target.setBeforeNode(null);
                    target.setNextNode(first);
                } else {
                    target.setNextNode(tobe.getNextNode());
                    tobe.setNextNode(target);
                }
            }
        }
    }

    public AddressResponse getConnectAddress(Long userId, Long channelId) {
        channelRepository.findById(channelId)
                .filter(c -> c.getStatus().equals(ChannelStatus.NORMAL))
                .filter(c -> c.getType().equals(ChannelType.VOICE))
                .orElseThrow(() -> new CustomException(NON_VALID_CHANNEL));

        String address = getInstance(channelId);

        return new AddressResponse(address);
    }

    private String getInstance(Long channelId) {
        List<String> keys = (List<String>) redisTemplate.keys("*").stream()
                .filter(k -> String.valueOf(k).contains("server"))
                .collect(Collectors.toList());

        SetOperations<String, String> setOperations = redisTemplate.opsForSet();
        String leastUsedInstance = keys.get(0);
        int min = -1;
        for (String key: keys) {
            if (setOperations.members(key).contains("c" + channelId))
                return key.split("-")[1];
            if (min < setOperations.members(key).size()) {
                leastUsedInstance = key;
                min = setOperations.members(key).size();
            }
        }
        return leastUsedInstance.split("-")[1];
    }
}
