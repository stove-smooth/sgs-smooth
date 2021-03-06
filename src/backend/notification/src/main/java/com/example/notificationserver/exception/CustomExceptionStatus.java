package com.example.notificationserver.exception;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum CustomExceptionStatus {

    SUCCESS(true, 1000, "요청에 성공하였습니다."),
    BAD_REQUEST(false, 1400, "잘못된 요청입니다."),
    NON_AUTHORIZATION(false, 1401, "요청 권한이 없습니다." ),
    INTERNAL_SERVER_ERROR(false, 1500, "서버 내부 에러입니다."),

    // 6000 ~ 6999
    FIREBASE_ERROR(false, 6000, "메세지 전송 에러입니다."),
    MESSAGE_TYPE_ERROR(false, 6001, "메세지 타입 에러입니다."),
    EMPTY_DEVICE(false, 6002, "등록되지 않은 디바이스입니다."),
    REDIS_DEVICE_TOKEN_PARSE_ERROR(false, 6003,"저장된 토큰 정보를 불러오는 중 에러가 발생했습니다.");

    private final boolean isSuccess;
    private final int code;
    private final String message;
}