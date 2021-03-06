package com.example.communityserver.domain.type;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum CommonStatus {
    NORMAL("일반"),
    DELETED("삭제");

    private final String description;
}
