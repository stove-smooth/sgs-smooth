package com.example.authserver.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SignInResponse {

    private Long id;

    private String name;

    private String code;

    private String email;

    private String accessToken;

    private String refreshToken;

    private String deviceToken;

    private String type;
}
