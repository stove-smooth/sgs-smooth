package com.example.chatserver.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class FileUploadRequest {

    private String type;

    private MultipartFile image;

    private MultipartFile thumbnail;

    private Long userId;

    private Long communityId;

    private Long channelId;

    private String fileType;
}
