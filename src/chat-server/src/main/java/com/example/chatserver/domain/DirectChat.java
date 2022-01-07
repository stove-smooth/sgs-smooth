package com.example.chatserver.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

@Document(collation = "direct-chat")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class DirectChat {

    @Id
    @Field("id")
    private String id;

    private String user;
    private String content;
    private String timestamp;

    private Long roomId;

}
