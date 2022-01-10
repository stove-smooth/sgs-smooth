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
public class CreateCommunityResponse {
    private Long communityId;
    private String name;
    private String iconImage;

    public static CreateCommunityResponse fromEntity(Community community) {
        return new CreateCommunityResponse(
                community.getId(), community.getName(), community.getIconImage());
    }
}
