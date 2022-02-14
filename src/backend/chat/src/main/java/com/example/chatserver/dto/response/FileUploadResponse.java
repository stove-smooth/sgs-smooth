package com.example.chatserver.dto.response;

import com.example.chatserver.domain.ChannelMessage;
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
    private Long userId;
    private Long channelId;
    private String type;
    private String fileType;
    private LocalDateTime time;

    @Override
    public String toString() {
        return "{" +
                "id='" + id + '\'' +
                ", name='" + name + '\'' +
                ", profileImage='" + profileImage + '\'' +
                ", message='" + message + '\'' +
                ", thumbnail='" + thumbnail + '\'' +
                ", userId=" + userId +
                ", channelId=" + channelId +
                ", type='" + type + '\'' +
                ", fileType='" + fileType + '\'' +
                ", time=" + time +
                '}';
    }
}
