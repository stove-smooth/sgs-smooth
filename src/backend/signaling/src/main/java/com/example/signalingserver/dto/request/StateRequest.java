package com.example.signalingserver.dto.request;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class StateRequest {

    private String type;
    private String sessionId;
    private String userId;
    private String channelId;
    private String roomId;

    public StateRequest(String type, String sessionId, String userId, String id) {
        this.type = type;
        this.sessionId = sessionId;
        this.userId = userId;
        if (id.contains("c-")) {
            this.channelId = id;
        } else
            this.roomId = id;
    }

    @Override
    public String toString() {
        return "{" +
                "type='" + type + '\'' +
                ", sessionId='" + sessionId + '\'' +
                ", userId='" + userId + '\'' +
                ", channelId='" + channelId + '\'' +
                ", roomId='" + roomId + '\'' +
                '}';
    }
}