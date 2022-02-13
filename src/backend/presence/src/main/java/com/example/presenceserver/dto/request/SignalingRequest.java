package com.example.presenceserver.dto.request;

import lombok.*;

import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class SignalingRequest {

    private String type;
    private String communityId;
    private String channelId;
    private List<String> ids;


}