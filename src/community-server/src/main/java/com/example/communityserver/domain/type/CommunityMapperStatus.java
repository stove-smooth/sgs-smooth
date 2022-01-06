package com.example.communityserver.domain.type;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum CommunityMapperStatus {
    NORMAL("일반"),
    DELETED("추방"),
    SUSPENDED("차단");

    private final String description;
}
