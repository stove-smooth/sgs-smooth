package com.example.chatserver.dto.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class LoginSessionRequest implements Serializable {
    private String type;
    private String session_id;
    private String user_id;

    @Override
    public String toString() {
        return "{" +
                "type='" + type + '\'' +
                ", session_id='" + session_id + '\'' +
                ", user_id='" + user_id + '\'' +
                '}';
    }
}
