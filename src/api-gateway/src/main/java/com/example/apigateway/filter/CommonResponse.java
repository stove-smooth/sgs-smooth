package com.example.apigateway.filter;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;


@Getter
@Setter
@NoArgsConstructor
public class CommonResponse implements Serializable {

    protected Boolean isSuccess;

    protected int code;

    protected String message;

    @Override
    public String toString() {
        return
                "isSuccess=" + isSuccess +
                ", code=" + code +
                ", message='" + message;
    }
}
