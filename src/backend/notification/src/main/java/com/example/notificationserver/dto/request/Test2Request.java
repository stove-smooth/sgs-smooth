package com.example.notificationserver.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Test2Request {
    private String token;
    private String platform;
    private Long communityId;
    private Long channelId;
}
