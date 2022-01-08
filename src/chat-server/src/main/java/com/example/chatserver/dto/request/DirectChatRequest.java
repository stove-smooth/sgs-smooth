package com.example.chatserver.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class DirectChatRequest {

    private Long channel_id;

    private String userId;

    private String content;
}
