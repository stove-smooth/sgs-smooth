package com.example.chatserver.dto.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.List;

@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class LoginSessionRequest implements Serializable {
    private String type;
    private String session_id;
    private String user_id;
    private String channel_id;
    private String community_id;
    private List<Long> ids;

    @Override
    public String toString() {
        return "{" +
                "type='" + type + '\'' +
                ", session_id='" + session_id + '\'' +
                ", user_id='" + user_id + '\'' +
                ", channel_id='" + channel_id + '\'' +
                ", community_id='" + community_id + '\'' +
                ", ids=" + ids +
                '}';
    }
}
