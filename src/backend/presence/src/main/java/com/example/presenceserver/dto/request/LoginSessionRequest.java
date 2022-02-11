package com.example.presenceserver.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class LoginSessionRequest {
    private String type;
    private String session_id;
    private String user_id;
    private String channel_id;
    private String community_id;
    private List<Long> ids;
}
