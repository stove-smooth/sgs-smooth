package com.example.communityserver.dto.response;

import com.example.communityserver.domain.Category;
import com.example.communityserver.domain.Community;
import com.example.communityserver.domain.type.CommonStatus;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CommunityDetailResponse {
    private Long id;
    private String name;
    private List<CategoryResponse> categories;

    public static CommunityDetailResponse fromEntity(Community community) {
        CommunityDetailResponse communityResponse = new CommunityDetailResponse();
        communityResponse.setId(community.getId());
        communityResponse.setName(community.getName());

        Category firstCategory = community.getCategories().stream()
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .filter(c -> c.isFirstNode())
                .findFirst().orElse(null);
        if (Objects.isNull(firstCategory))
            return communityResponse;

        List<CategoryResponse> categories = new ArrayList<>();
        categories.add(CategoryResponse.fromEntity(firstCategory));
        Category nextNode = firstCategory.getNextNode();
        while (!Objects.isNull(nextNode)) {
            if (nextNode.getStatus().equals(CommonStatus.NORMAL))
                categories.add(CategoryResponse.fromEntity(nextNode));
            nextNode = nextNode.getNextNode();
        }
        communityResponse.setCategories(categories);
        return communityResponse;
    }

}