package com.example.communityserver.domain.type;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum ChannelType {
    TEXT("텍스트"),
    VOICE("음성");

    private final String description;
}
