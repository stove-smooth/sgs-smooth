package com.example.chatserver.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class CommonResponse {

    protected Boolean isSuccess;
    protected int code;
    protected String message;
}
