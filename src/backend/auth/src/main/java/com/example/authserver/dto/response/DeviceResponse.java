package com.example.authserver.dto.response;

import lombok.*;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class DeviceResponse {

    private String type;

    private String token;
}
