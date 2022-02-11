package com.example.chatserver.dto.response;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MessageCountResponse {

    private Long roomId;
    private Integer count;
}
