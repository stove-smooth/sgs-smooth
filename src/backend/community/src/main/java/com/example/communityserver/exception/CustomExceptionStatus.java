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
    NON_VALID_CATEGORY(false, 4003, "유효하지 않은 카테고리입니다."),
    NON_VALID_CHANNEL(false, 4004, "커뮤니티에 속한 채널이 아닙니다."),
    NON_VALID_INVITATION(false, 4005, "유효하지 않은 초대장입니다."),
    SUSPENDED_COMMUNITY(false, 4006, "차단된 커뮤니티입니다."),
    EMPTY_MEMBER(false, 4007, "존재하지 않는 회원입니다."),
    NON_VALID_COMMUNITY_SEQUENCE(false, 4008, "커뮤니티 순서가 올바르지 않습니다."),
    ALREADY_LOCATED(false, 4009, "이미 해당 위치에 존재하고 있습니다."),
    NON_VALID_USER_ID_IN_COMMUNITY(false, 4010, "커뮤니티에 존재하지 않는 회원입니다."),
    NON_VALID_NEXT_NODE(false, 4011, "변경될 위치가 유효하지 않습니다."),
    ALREADY_PUBLIC_STATE(false, 4012, "공개된 채널입니다."),
    ALREADY_INVITED(false, 4013, "이미 초대되어 있습니다."),
    CANT_SUSPEND_YOURSELF(false, 4014, "스스로를 추방할 수 없습니다."),
    NON_EXIST_OWNER(false, 4015, "커뮤니티의 소유주가 없습니다."),
    NON_SERVE_IN_THREAD(false, 4016, "스레드에서 제공하지 않는 기능입니다."),
    EMPTY_USER_IN_ROOM(false, 4017, "방에 다른 사용자가 존재하지 않습니다."),
    NON_VALID_ROOM(false, 4018, "유효하지 않은 채팅방입니다."),
    CANT_EXCHANGE_PERSONAL_ROOM(false, 4019, "개인 채팅방은 수정할 수 없습니다."),
    CANT_INVITE_SELF(false, 4020, "스스로를 채팅방에 초대할 수 없습니다."),
    MEMBER_REQUIRED(false, 4021, "초대하는 사용자의 수가 부족합니다."),
    FILE_DELETE_ERROR(false, 4022, "파일 삭제 중 에러가 발생했습니다."),
    EMPTY_REGISTERED_SERVER(false, 4023, "등록된 서버가 없습니다.");

    private final boolean isSuccess;
    private final int code;
    private final String message;
}