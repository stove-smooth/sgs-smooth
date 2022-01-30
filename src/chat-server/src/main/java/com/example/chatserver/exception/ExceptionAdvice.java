package com.example.chatserver.exception;


import com.example.chatserver.dto.response.CommonResponse;
import com.example.chatserver.service.ResponseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@Slf4j
@RequiredArgsConstructor
@RestControllerAdvice
public class ExceptionAdvice {

    private final ResponseService responseService;

    @ExceptionHandler(CustomException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    protected CommonResponse customException(CustomException customException) {
        CustomExceptionStatus status = customException.getCustomExceptionStatus();
        return responseService.getExceptionResponse(status);
    }
}
