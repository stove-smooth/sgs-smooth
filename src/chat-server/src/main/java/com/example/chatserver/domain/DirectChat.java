package com.example.chatserver.domain;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Document(collation = "direct-chat")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class DirectChat {

    @Id
    @Field("id")
    private String id;

    private Long community_id;

    private Long category_id;

    private Long channel_id;

    private Long user_id;

    private String content;

    private LocalDateTime dateTime;

    private Map<Long,Boolean> read;

}
