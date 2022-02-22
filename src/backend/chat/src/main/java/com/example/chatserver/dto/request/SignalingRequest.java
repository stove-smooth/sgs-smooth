package com.example.chatserver.dto.request;

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

    @Override
    public String toString() {
        return "{" +
                "type='" + type + '\'' +
                ", communityId='" + communityId + '\'' +
                ", channelId='" + channelId + '\'' +
                ", ids=" + ids +
                '}';
    }
}
