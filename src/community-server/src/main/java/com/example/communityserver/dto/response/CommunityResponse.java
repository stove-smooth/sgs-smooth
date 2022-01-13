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
    private Long communityId;
    private String name;
    private String iconImage;

    public static CommunityResponse fromEntity(Community community) {
        CommunityResponse communityResponse = new CommunityResponse();
        communityResponse.setCommunityId(community.getId());
        communityResponse.setName(community.getName());
        communityResponse.setIconImage(community.getIconImage());
        return communityResponse;
    }
}
