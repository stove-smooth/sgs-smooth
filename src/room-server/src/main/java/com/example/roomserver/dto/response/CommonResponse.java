package com.example.roomserver.dto.response;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class CommonResponse {

    protected Boolean isSuccess;
    protected int code;
    protected String message;
}