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
    private String community_id;
    private String channel_id;

    public StateRequest(String type, String sessionId, String userId, String community_id, String channel_id) {
        this.type = type;
        this.session_id = sessionId;
        this.user_id = userId;
        this.community_id = community_id;
        if (community_id.equals("0"))
            this.community_id = null;
        this.channel_id = channel_id;
    }

    @Override
    public String toString() {
        return "{" +
                "type='" + type + '\'' +
                ", session_id='" + session_id + '\'' +
                ", user_id='" + user_id + '\'' +
                ", community_id='" + community_id + '\'' +
                ", channel_id='" + channel_id + '\'' +
                '}';
    }
}