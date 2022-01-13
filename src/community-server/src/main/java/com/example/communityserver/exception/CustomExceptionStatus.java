package com.example.communityserver.exception;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum CustomExceptionStatus {

    SUCCESS(true, 1000, "요청에 성공하였습니다."),
    BAD_REQUEST(false, 1400, "잘못된 요청입니다."),
    NON_AUTHORIZATION(false, 1401, "요청 권한이 없습니다." ),
    INTERNAL_SERVER_ERROR(false, 1500, "서버 내부 에러입니다."),

    // 4000 ~ 4999
    FILE_CONVERT_ERROR(false, 4000, "파일 변환 중 에러가 발생했습니다."),
    FILE_EXTENSION_ERROR(false, 4001, "파일의 확장자가 유효하지 않습니다."),
    NON_VALID_COMMUNITY(false, 4002, "유효하지 않는 커뮤니티입니다."),
    NON_VALID_CATEGORY(false, 4003, "유효하지 않은 채널입니다."),
    NON_VALID_CHANNEL(false, 4004, "커뮤니티에 속한 채널이 아닙니다."),
    NON_VALID_INVITATION(false, 4005, "유효하지 않은 초대장입니다."),
    SUSPENDED_COMMUNITY(false, 4006, "차단된 커뮤니티입니다."),
    EMPTY_MEMBER(false, 4007, "존재하지 않는 회원입니다."),
    NON_VALID_COMMUNITY_SEQUENCE(false, 4008, "커뮤니티 순서가 올바르지 않습니다.");

    private final boolean isSuccess;
    private final int code;
    private final String message;
}