package com.example.chatserver.exception;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum CustomExceptionStatus {
    /**
     * 1000 : 요청 성공
     */
    SUCCESS(true, 1000, "요청에 성공하였습니다."),


    /**
     * 2100 : Request 오류
     */
    // Common
    REQUEST_ERROR(false, 2100, "입력값을 확인해주세요."),
    EMPTY_JWT(false, 2101, "JWT를 입력해주세요."),
    INVALID_JWT(false, 2102, "유효하지 않은 JWT입니다."),
    INVALID_USER_JWT(false,2103,"권한이 없는 유저의 접근입니다."),
    NOT_AUTHENTICATED_ACCOUNT(false, 2104, "로그인이 필요합니다."),

    // message
    USERS_EMPTY_USER_ID(false, 2110, "유저 아이디 값을 확인해주세요."),
    MESSAGE_NOT_FOUND(false, 4111, "메세지를 찾을 수 없습니다."),
    ACCOUNT_NOT_VALID(false, 2112, "유효한 사용자가 아닙니다."),
    ACCOUNT_NOT_VALID_ROLE(false, 2113, "유효한 Role 형식이 아닙니다."),

    // [POST] /users
    POST_USERS_EMPTY_EMAIL(false, 2120, "이메일을 입력해주세요."),
    POST_USERS_INVALID_EMAIL(false, 2121, "이메일 형식을 확인해주세요."),
    POST_USERS_EXISTS_EMAIL(false,2122,"중복된 이메일입니다."),
    POST_USERS_EMPTY_NICKNAME(false, 2123, "닉네임을 입력해주세요."),
    POST_USERS_INVALID_NICKNAME(false, 2124, "닉네임 형식을 확인해주세요."),
    POST_USERS_EXISTS_NICKNAME(false,2125,"중복된 닉네임입니다."),
    POST_USERS_INVALID_PASSWORD(false, 2126, "비밀번호 형식을 확인해주세요."),
    POST_USERS_EMPTY_PASSWORD(false, 2127, "비밀번호를 입력해주세요"),
    POST_USERS_EMPTY_ID(false, 2128, "아이디를 입력해주세요."),
    POST_USERS_INVALID_ID(false, 2129, "아이디 형식을 확인해주세요."),
    POST_USERS_EXISTS_ID(false,2130,"중복된 아이디입니다."),

    // Role
    ACCOUNT_ACCESS_DENIED(false, 2150, "권한이 없습니다."),

    // friend
    FRIEND_NOT_FOUND(false, 2170, "친구 목록을 찾을 수 없습니다."),

    // email
    NOT_VALID_CODE(false,2180,"유효하지 않은 인증번호입니다."),

    /**
     * 2200 : Response 오류
     */
    // Common
    RESPONSE_ERROR(false, 2200, "값을 불러오는데 실패하였습니다."),

    // [POST] /users
    DUPLICATED_EMAIL(false, 2210, "중복된 이메일입니다."),
    DUPLICATED_NICKNAME(false, 2211, "중복된 닉네임입니다."),
    DUPLICATED_NICKNAME_SELF(false, 2212, "원래의 닉네임과 중복됩니다."),
    FAILED_TO_LOGIN(false,2213,"없는 아이디이거나 비밀번호가 틀렸습니다."),
    ALREADY_CERTIFICATION_ACCOUNT(false,2214,"이미 인증된 유저입니다."),
    FAILED_TO_CERTIFICATION(false,2215,"유효한 토큰 값이 아닙니다."),
    FAILED_TO_RECEPTION(false,2216,"유효한 수신 번호가 아닙니다."),
    DUPLICATED_ID(false, 2217, "중복된 아이디입니다."),

    /**
     * 2300 : Database, Server 오류
     */
    DATABASE_ERROR(false, 2300, "데이터베이스 연결에 실패하였습니다."),
    SERVER_ERROR(false, 2301, "서버와의 연결에 실패하였습니다."),

    //[PATCH] /users/{userIdx}
    MODIFY_FAIL_USERNAME(false,2310,"유저네임 수정 실패");

    // 5000

    // 6000


    private final boolean isSuccess;
    private final int code;
    private final String message;
}
