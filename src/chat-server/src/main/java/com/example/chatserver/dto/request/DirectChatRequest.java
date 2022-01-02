package com.example.chatserver.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class DirectChatRequest {

    private String user;

    private String content;

    private Long roomId;
}
