package com.example.notificationserver.exception;

import com.example.notificationserver.dto.response.CommonResponse;
import com.example.notificationserver.service.ResponseService;
import com.fasterxml.jackson.databind.exc.InvalidFormatException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.validation.BindException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentConversionNotSupportedException;
import org.springframework.web.multipart.MultipartException;

@Slf4j
@RequiredArgsConstructor
@RestControllerAdvice
public class ExceptionAdvice {

    private final ResponseService responseService;

    // Custom exception
    @ExceptionHandler(CustomException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    protected CommonResponse customException(CustomException customException) {
        CustomExceptionStatus status = customException.getCustomExceptionStatus();
        log.error("code: {}, message: {}",
                status.getCode(), status.getMessage());
        return responseService.getExceptionResponse(status);
    }

    // Bad request
    @ExceptionHandler(value = {
            HttpRequestMethodNotSupportedException.class,
            MethodArgumentNotValidException.class,
            InvalidFormatException.class,
            MultipartException.class,
            MethodArgumentConversionNotSupportedException.class,
            BindException.class
    })
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public CommonResponse handleBadRequest(Exception e) {
        CustomExceptionStatus status = CustomExceptionStatus.BAD_REQUEST;
        log.error("code: {}, message: {}",
                status.getCode(), e.getMessage());
        return responseService.getExceptionResponse(status);
    }

    // Other exception
    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public CommonResponse handleException(Exception e) {
        CustomExceptionStatus status = CustomExceptionStatus.INTERNAL_SERVER_ERROR;
        log.error("code: {}, message: {}",
                status.getCode(), e.getMessage());
        e.printStackTrace();
        return responseService.getExceptionResponse(status);
    }
}