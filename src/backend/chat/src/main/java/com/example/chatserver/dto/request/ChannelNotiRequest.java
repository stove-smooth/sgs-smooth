package com.example.chatserver.dto.request;

import lombok.*;

import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ChannelNotiRequest {

    private Long userId;

    private String username;

    private String type;

    private String content;

    private String channelName;

    private Long communityId;

    private Long channelId;

    private String target;
}
