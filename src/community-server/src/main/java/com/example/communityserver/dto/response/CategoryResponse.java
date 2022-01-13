package com.example.communityserver.dto.response;

import com.example.communityserver.domain.Category;
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
public class CategoryResponse {
    private Long categoryId;
    private String name;
    private List<ChannelResponse> channels;

    public static CategoryResponse fromEntity(Category category) {
        CategoryResponse categoryResponse = new CategoryResponse();
        categoryResponse.setCategoryId(category.getId());
        categoryResponse.setName(category.getName());
        categoryResponse.setChannels(category.getChannels().stream()
                .map(ChannelResponse::fromEntity)
                .collect(Collectors.toList()));
        return categoryResponse;
    }
}
