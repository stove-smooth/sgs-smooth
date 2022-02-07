package com.example.chatserver.dto.response;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FileUploadResponse {
    private String id;
    private String name;
    private String profileImage;
    private String message;
    private String thumbnail;
    private Long channelId;
    private String type;
    private LocalDateTime time;
}