package com.example.communityserver.dto.response;

import com.example.communityserver.domain.Category;
import com.example.communityserver.domain.Channel;
import com.example.communityserver.domain.type.ChannelStatus;
import com.example.communityserver.domain.type.CommonStatus;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CategoryResponse {
    private Long id;
    private String name;
    private List<ChannelResponse> channels;

    public static CategoryResponse fromEntity(Category category) {
        CategoryResponse categoryResponse = new CategoryResponse();
        categoryResponse.setId(category.getId());
        categoryResponse.setName(category.getName());

        Channel firstChannel = category.getChannels().stream()
                .filter(c -> c.getStatus().equals(ChannelStatus.NORMAL)
                    && Objects.isNull(c.getBeforeNode()))
                .findFirst().orElse(null);
        if (Objects.isNull(firstChannel))
            return categoryResponse;

        List<ChannelResponse> channels = new ArrayList<>();
        channels.add(ChannelResponse.fromEntity(firstChannel));
        Channel nextNode = firstChannel.getNextNode();
        while (!Objects.isNull(nextNode)) {
            if (nextNode.getStatus().equals(ChannelStatus.NORMAL))
                channels.add(ChannelResponse.fromEntity(nextNode));
            nextNode = nextNode.getNextNode();
        }
        categoryResponse.setChannels(channels);
        return categoryResponse;
    }
}
