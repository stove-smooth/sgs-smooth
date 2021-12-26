package com.example.authserver.configure.exception;

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
     * 2000 : Request 오류
     */
    // Common
    REQUEST_ERROR(false, 2000, "입력값을 확인해주세요."),
    EMPTY_JWT(false, 2001, "JWT를 입력해주세요."),
    INVALID_JWT(false, 2002, "유효하지 않은 JWT입니다."),
    INVALID_USER_JWT(false,2003,"권한이 없는 유저의 접근입니다."),
    NOT_AUTHENTICATED_ACCOUNT(false, 2004, "로그인이 필요합니다."),

    // users
    USERS_EMPTY_USER_ID(false, 2010, "유저 아이디 값을 확인해주세요."),
    ACCOUNT_NOT_FOUND(false, 2011, "사용자를 찾을 수 없습니다."),
    ACCOUNT_NOT_VALID(false, 2012, "유효한 사용자가 아닙니다."),
    ACCOUNT_NOT_VALID_ROLE(false, 2013, "유효한 Role 형식이 아닙니다."),

    // [POST] /users
    POST_USERS_EMPTY_EMAIL(false, 2020, "이메일을 입력해주세요."),
    POST_USERS_INVALID_EMAIL(false, 2021, "이메일 형식을 확인해주세요."),
    POST_USERS_EXISTS_EMAIL(false,2022,"중복된 이메일입니다."),
    POST_USERS_EMPTY_NICKNAME(false, 2023, "닉네임을 입력해주세요."),
    POST_USERS_INVALID_NICKNAME(false, 2024, "닉네임 형식을 확인해주세요."),
    POST_USERS_EXISTS_NICKNAME(false,2025,"중복된 닉네임입니다."),
    POST_USERS_INVALID_PASSWORD(false, 2026, "비밀번호 형식을 확인해주세요."),
    POST_USERS_EMPTY_PASSWORD(false, 2027, "비밀번호를 입력해주세요"),
    POST_USERS_EMPTY_ID(false, 2028, "아이디를 입력해주세요."),
    POST_USERS_INVALID_ID(false, 2029, "아이디 형식을 확인해주세요."),
    POST_USERS_EXISTS_ID(false,2030,"중복된 아이디입니다."),

    // Role
    ACCOUNT_ACCESS_DENIED(false, 2050, "권한이 없습니다."),

    /**
     * 3000 : Response 오류
     */
    // Common
    RESPONSE_ERROR(false, 3000, "값을 불러오는데 실패하였습니다."),

    // [POST] /users
    DUPLICATED_EMAIL(false, 3010, "중복된 이메일입니다."),
    DUPLICATED_NICKNAME(false, 3011, "중복된 닉네임입니다."),
    DUPLICATED_NICKNAME_SELF(false, 3012, "원래의 닉네임과 중복됩니다."),
    FAILED_TO_LOGIN(false,3013,"없는 아이디이거나 비밀번호가 틀렸습니다."),
    ALREADY_CERTIFICATION_ACCOUNT(false,3014,"이미 인증된 유저입니다."),
    FAILED_TO_CERTIFICATION(false,3015,"유효한 토큰 값이 아닙니다."),
    FAILED_TO_RECEPTION(false,3016,"유효한 수신 번호가 아닙니다."),
    DUPLICATED_ID(false, 3017, "중복된 아이디입니다."),

    /**
     * 4000 : Database, Server 오류
     */
    DATABASE_ERROR(false, 4000, "데이터베이스 연결에 실패하였습니다."),
    SERVER_ERROR(false, 4001, "서버와의 연결에 실패하였습니다."),

    //[PATCH] /users/{userIdx}
    MODIFY_FAIL_USERNAME(false,4010,"유저네임 수정 실패"),

    PASSWORD_ENCRYPTION_ERROR(false, 4020, "비밀번호 암호화에 실패하였습니다."),
    PASSWORD_DECRYPTION_ERROR(false, 4021, "비밀번호 복호화에 실패하였습니다.");


    // 5000

    // 6000


    private final boolean isSuccess;
    private final int code;
    private final String message;
}
