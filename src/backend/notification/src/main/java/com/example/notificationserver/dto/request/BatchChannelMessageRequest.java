package com.example.notificationserver.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BatchChannelMessageRequest {
    private LocalDateTime time;
    private ChannelMessageRequest request;
}
