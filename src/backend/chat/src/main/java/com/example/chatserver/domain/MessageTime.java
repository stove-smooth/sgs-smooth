package com.example.chatserver.domain;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;
import java.util.Map;

@Document(collection = "messageTime")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MessageTime {

    @Id
    private String id;

    private String channelId;

    private Map<String, LocalDateTime> read;
}
