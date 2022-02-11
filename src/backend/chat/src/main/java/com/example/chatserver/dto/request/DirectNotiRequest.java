package com.example.chatserver.dto.request;

import lombok.*;

import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class DirectNotiRequest {

    private Long userId;

    private String username;

    private String type;

    private String content;

    private String roomName;

    private Long roomId;

    private String target;
}
