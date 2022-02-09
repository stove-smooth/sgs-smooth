package com.example.notificationserver.domain;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import java.util.List;
import java.util.Map;

@Document(collation = "notification")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Notification {

    @Id
    @Field("id")
    private String id;

    private String title;

    private String body;

    private Map<String, String> data;

    private String image;

    private Map<String, String> token;

    private Map<String, String> send;
}
