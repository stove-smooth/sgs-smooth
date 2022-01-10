package com.example.communityserver.exception;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum CustomExceptionStatus {

    SUCCESS(true, 1000, "요청에 성공하였습니다."),
    BAD_REQUEST(false, 1400, "잘못된 요청입니다."),
    INTERNAL_SERVER_ERROR(false, 1500, "서버 내부 에러입니다.");

    // 4000 ~ 4999


    private final boolean isSuccess;
    private final int code;
    private final String message;
}