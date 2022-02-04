package com.example.communityserver.domain.type;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum CommunityRole {
    OWNER("소유주"),
    NONE("없음");

    private final String description;
}
