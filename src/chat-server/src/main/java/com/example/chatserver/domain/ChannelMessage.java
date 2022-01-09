package com.example.chatserver.domain;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import java.time.LocalDateTime;

@Document(collation = "channel-message")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ChannelMessage {

    @Id
    @Field("id")
    private String id;

    private Long channel_id;

    private Long account_id;

    private String content;

    private LocalDateTime localDateTime;
}
