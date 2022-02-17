package com.example.chatserver.dto.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class StateRequest {
    private String type;

    private String typeForExit;

    private String userId;

    private String state;

    private String communityId;

    private String channelId;

    private List<String> ids;


}
