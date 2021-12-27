package com.example.authserver.dto;

import com.example.authserver.domain.Account;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;

import static com.fasterxml.jackson.annotation.JsonProperty.Access;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AccountAutoDto {

    @NotBlank
    @Email
    private String email;

    @NotBlank
    @JsonProperty(access = Access.WRITE_ONLY)
    private String password;

    @NotBlank
    @Length(min=3, max = 20)
    @Pattern(regexp = "^[가-힣a-zA-Z0-9_-]{3,20}$")
    private String name;

    public AccountAutoDto(Account account) {
        this.email = account.getEmail();
        this.name = account.getName();
    }
}
