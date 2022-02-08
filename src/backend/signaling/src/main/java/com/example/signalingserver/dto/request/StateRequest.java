package com.example.signalingserver.dto.request;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class StateRequest {

    private String type;
    private String session_id;
    private String user_id;
    private String channel_id;
    private String room_id;


    public StateRequest(String type, String sessionId, String userId, String id) {
        this.type = type;
        this.session_id = sessionId;
        this.user_id = userId;
        if (id.contains("c-")) {
            this.channel_id = id;
        } else
            this.room_id = id;
    }

    @Override
    public String toString() {
        return "{" +
                "type='" + type + '\'' +
                ", session_id='" + session_id + '\'' +
                ", user_id='" + user_id + '\'' +
                ", channel_id='" + channel_id + '\'' +
                ", room_id='" + room_id + '\'' +
                '}';
    }
}