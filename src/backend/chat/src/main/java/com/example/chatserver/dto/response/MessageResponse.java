package com.example.chatserver.dto.response;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class MessageResponse {

    private String id;
    private String name;
    private String profileImage;
    private Long userId;
    private String message;
    private String thumbnail;
    private String fileType;
    private String type;
    private LocalDateTime time;
    private String parentId;
    private String parentName;
    private String parentContent;
}
