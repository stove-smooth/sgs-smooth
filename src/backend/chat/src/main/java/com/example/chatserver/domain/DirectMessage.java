package com.example.chatserver.domain;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;
import java.util.Map;

@Document(collection = "directMessage")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class DirectMessage {

    @Id
    private String id;

    private Long channelId;

    private Long userId;

    private String parentId;

    private String content;

    private String thumbnail;

    private LocalDateTime localDateTime;

    private Map<Long,Boolean> read;

    private String type;

    private String name;

    private String profileImage;

    private String parentName;

    private String parentContent;

}
