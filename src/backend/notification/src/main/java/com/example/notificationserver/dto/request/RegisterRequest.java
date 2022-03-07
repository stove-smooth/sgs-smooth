package com.example.notificationserver.dto.request;

import com.example.notificationserver.domain.type.Platform;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.validation.constraints.NotNull;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RegisterRequest {
    @NotNull
    private Long userId;

    @NotNull
    @Enumerated(EnumType.STRING)
    private Platform platform;

    @NotNull
    private String token;
}
