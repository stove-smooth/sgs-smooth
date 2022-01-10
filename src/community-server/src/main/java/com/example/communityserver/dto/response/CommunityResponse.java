package com.example.communityserver.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CommunityResponse {
    private Long communityId;
    private String name;
    private String iconImage;
    private int unread;
}
