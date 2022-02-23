package com.example.communityserver.dto.response;

import com.example.communityserver.domain.Channel;
import com.example.communityserver.domain.Community;
import com.example.communityserver.domain.type.ChannelStatus;
import com.example.communityserver.domain.type.ChannelType;
import com.example.communityserver.domain.type.CommunityMemberStatus;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ChannelDetailResponse {
    private Long id;
    private String username;
    private String name;
    @Enumerated(EnumType.STRING)
    private ChannelType type;
    private boolean isPublic;
    private ThreadResponse parent;
    private List<ThreadResponse> threads;
    private List<MemberResponse> members;

    public static ChannelDetailResponse fromEntity(Channel channel) {
        ChannelDetailResponse channelResponse = new ChannelDetailResponse();
        channelResponse.setId(channel.getId());
        channelResponse.setUsername(channel.getUsername());
        channelResponse.setName(channel.getName());
        channelResponse.setType(channel.getType());
        channelResponse.setPublic(channel.isPublic());
        if (!Objects.isNull(channel.getParent()))
            channelResponse.setParent(ThreadResponse.fromEntity(channel.getParent()));
        channelResponse.setThreads(channel.getThread().stream()
                .filter(t -> t.getStatus().equals(ChannelStatus.NORMAL))
                .map(ThreadResponse::fromEntity)
                .collect(Collectors.toList()));
        return channelResponse;
    }

    public static List<MemberResponse> fromMember(Community community, List<Long> memberIds, Map<Long, UserResponse> userMap) {
        return community.getMembers().stream()
                .filter(member -> member.getStatus().equals(CommunityMemberStatus.NORMAL))
                .filter(member -> memberIds.contains(member.getUserId()))
                .map(member -> MemberResponse.fromEntity(member, userMap.get(member.getUserId())))
                .collect(Collectors.toList());
    }

    public static List<MemberResponse> fromMemberV2(Community community, List<Long> memberIds, Map<Long, UserResponse> userMap, Map<Long, UserResponse> userMap2) {
        return community.getMembers().stream()
                .filter(member -> member.getStatus().equals(CommunityMemberStatus.NORMAL))
                .filter(member -> memberIds.contains(member.getUserId()))
                .map(member -> MemberResponse.fromEntityV2(member, userMap.get(member.getUserId()), userMap2.get(member.getUserId()).getState()))
                .collect(Collectors.toList());
    }
}
