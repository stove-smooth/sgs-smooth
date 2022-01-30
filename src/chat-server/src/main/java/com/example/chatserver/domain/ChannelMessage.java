package com.example.chatserver.domain;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Document(collection = "channelMessage")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ChannelMessage {

    @Id
    private String id;

    private Long communityId;

    private Long categoryId;

    private Long channelId;

    private Long accountId;

    private String parentId;

    private String content;

    private LocalDateTime localDateTime;

    private Map<Long,Boolean> read;
}
