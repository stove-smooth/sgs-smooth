package com.example.authserver.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class AccountInfoResponse {

    private Long id;

    private String name;

    private String image;

    private String state;
}
