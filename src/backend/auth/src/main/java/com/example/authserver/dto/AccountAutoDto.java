package com.example.authserver.dto;

import com.example.authserver.domain.User;
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

    private Long id;

    @NotBlank
    @Email
    private String email;

    @NotBlank
    @Length(min=8, max = 15)
    @JsonProperty(access = Access.WRITE_ONLY)
    private String password;

    @NotBlank
    @Length(min=2, max = 15)
    @Pattern(regexp = "^[가-힣a-zA-Z0-9_-]{2,20}$")
    private String name;

    private String code;

    private String bio;

    private String profileImage;


    public AccountAutoDto(User account) {
        this.id = account.getId();
        this.email = account.getEmail();
        this.name = account.getName();
        this.code = account.getCode();
        this.bio = account.getBio();
        this.profileImage = account.getProfileImage();
    }
}
