package com.example.chatserver.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class PresenceInfoFeignResponse {

    private Boolean isSuccess;
    private int code;
    private String message;
}
