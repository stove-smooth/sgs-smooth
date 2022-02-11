package com.example.chatserver.dto.response;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MessageCountResponse {

    private Long roomId;
    private Integer count;
    private String localDateTime;
}
