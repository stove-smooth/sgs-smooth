package com.example.authserver.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotBlank;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FriendRequest {

    @NotBlank
    private String name;

    @NotBlank
    @Length(min = 4, max = 4)
    private String code;
}
