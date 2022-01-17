package com.example.communityserver.dto.response;

import com.example.communityserver.domain.Channel;
import com.example.communityserver.domain.type.ChannelType;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ChannelResponse {
    private Long channelId;
    private String username;
    private String name;
    @Enumerated(EnumType.STRING)
    private ChannelType type;
    private boolean isPublic;
    private ThreadResponse parent;
    private List<ThreadResponse> threads;

    public static ChannelResponse fromEntity(Channel channel) {
        ChannelResponse channelResponse = new ChannelResponse();
        channelResponse.setChannelId(channel.getId());
        channelResponse.setUsername(channel.getUsername());
        channelResponse.setName(channel.getName());
        channelResponse.setType(channel.getType());
        channelResponse.setPublic(channel.isPublic());
        if (!Objects.isNull(channel.getParent()))
            channelResponse.setParent(ThreadResponse.fromEntity(channel.getParent()));
        channelResponse.setThreads(channel.getThread().stream()
                .map(ThreadResponse::fromEntity)
                .collect(Collectors.toList()));
        return channelResponse;
    }
}
