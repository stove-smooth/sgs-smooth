package com.example.notificationserver.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.validation.constraints.NotNull;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ChannelMessageRequest {

    @NotNull
    private Long userId;

    @NotNull
    private String username;

    @NotNull
    private String type;

    @NotNull
    private String content;

    @NotNull
    private String channelName;

    @NotNull
    private Long communityId;

    @NotNull
    private Long channelId;

    @NotNull
    private String target;
}