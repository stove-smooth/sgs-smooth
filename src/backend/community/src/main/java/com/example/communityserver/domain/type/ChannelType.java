package com.example.communityserver.domain.type;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum ChannelType {
    TEXT("채팅 채널"),
    VOICE("음성 채널");

    private final String description;
}
