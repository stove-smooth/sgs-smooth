package com.example.authserver.configure.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class CustomException extends RuntimeException{
    CustomExceptionStatus customExceptionStatus;
}
