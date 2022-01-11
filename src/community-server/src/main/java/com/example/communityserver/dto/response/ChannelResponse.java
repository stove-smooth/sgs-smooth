package com.example.communityserver.dto.response;

import com.example.communityserver.domain.type.ChannelType;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ChannelResponse {
    private Long channelId;
    private String name;
    @Enumerated(EnumType.STRING)
    private ChannelType type;
    private boolean isPublic;
    private List<ThreadResponse> threads;
}
