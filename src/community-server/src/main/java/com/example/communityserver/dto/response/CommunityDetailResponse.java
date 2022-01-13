package com.example.communityserver.dto.response;

import com.example.communityserver.domain.Community;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;
import java.util.stream.Collectors;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CommunityDetailResponse {
    private Long communityId;
    private String name;
    private List<CategoryResponse> categories;

    public static CommunityDetailResponse fromEntity(Community community) {
        CommunityDetailResponse communityResponse = new CommunityDetailResponse();
        communityResponse.setCommunityId(community.getId());
        communityResponse.setName(community.getName());
        communityResponse.setCategories(community.getCategories().stream()
                .map(CategoryResponse::fromEntity)
                .collect(Collectors.toList()));
        return communityResponse;
    }

}