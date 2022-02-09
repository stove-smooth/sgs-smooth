package com.example.communityserver.domain.type;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum ChannelStatus {
    NORMAL("일반"),
    SAVED("보관"),
    DELETED("삭제");

    private final String description;
}
