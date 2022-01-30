package com.example.chatserver.exception;

import org.springframework.validation.Errors;

public class ValidationExceptionProvider {

    public static void throwValidError(Errors errors) {
        String errorCode = errors.getFieldError().getCode();
        String errorTarget = errors.getFieldError().getField();
        throw new CustomException(ValidationExceptionProvider.getExceptionStatus(errorCode, errorTarget));
    }

    public static CustomExceptionStatus getExceptionStatus(String code, String target) {
        if (code.equals("NotBlank")){
            if (target.equals("signInId")) return CustomExceptionStatus.POST_USERS_EMPTY_ID;
            else if (target.equals("email")) return CustomExceptionStatus.POST_USERS_EMPTY_EMAIL;
            else if (target.equals("password")) return CustomExceptionStatus.POST_USERS_EMPTY_PASSWORD;
            else if (target.equals("nickname")) return CustomExceptionStatus.POST_USERS_EMPTY_NICKNAME;
        }
        else if (code.equals("Pattern") || code.equals("Length")){
            if (target.equals("signInId")) return CustomExceptionStatus.POST_USERS_INVALID_ID;
            else if (target.equals("nickname")) return CustomExceptionStatus.POST_USERS_INVALID_NICKNAME;
            else if (target.equals("password")) return CustomExceptionStatus.POST_USERS_INVALID_PASSWORD;
        }
        else if (code.equals("Email")) {
            return CustomExceptionStatus.POST_USERS_INVALID_EMAIL;
        }
        return CustomExceptionStatus.RESPONSE_ERROR;
    }
}
