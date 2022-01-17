package com.example.communityserver.dto.response;

import com.example.communityserver.domain.Community;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CommunityResponse {
    private Long id;
    private String name;
    private String icon;

    public static CommunityResponse fromEntity(Community community) {
        CommunityResponse communityResponse = new CommunityResponse();
        communityResponse.setId(community.getId());
        communityResponse.setName(community.getName());
        communityResponse.setIcon(community.getIconImage());
        return communityResponse;
    }
}
