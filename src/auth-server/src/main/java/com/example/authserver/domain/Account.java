package com.example.authserver.domain;

import com.example.authserver.dto.AccountAutoDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Entity
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Account {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false)
    private String name;

    @Enumerated(EnumType.STRING)
    private RoleType roleType;

    @Enumerated(EnumType.STRING)
    private Status status;

    private String profileImage;

    public static Account createAccount(AccountAutoDto dto) {
        return Account.builder()
                .email(dto.getEmail())
                .password(dto.getPassword())
                .name(dto.getName())
                .status(Status.VALID)
                .roleType(RoleType.ROLE_USER)
                .build();
    }
    public void changeRole(RoleType roleType) {
        this.roleType = roleType;
    }

}
