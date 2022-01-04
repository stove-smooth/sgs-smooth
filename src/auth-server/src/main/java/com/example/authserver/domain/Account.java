package com.example.authserver.domain;

import com.example.authserver.domain.type.RoleType;
import com.example.authserver.domain.type.State;
import com.example.authserver.domain.type.Status;
import com.example.authserver.dto.AccountAutoDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Account {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "account_id")
    private Long id;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false, length = 15)
    private String name;

    @Column(nullable = false, length = 4)
    private String code;

    @Enumerated(EnumType.STRING)
    private RoleType roleType;

    @Enumerated(EnumType.STRING)
    private Status status;

    @Enumerated(EnumType.STRING)
    private State state;

    private String profileImage;

    @OneToMany(mappedBy = "receiver",cascade = CascadeType.ALL)
    private List<Friend> friendList = new ArrayList<>();

    @OneToMany(mappedBy = "sender",cascade = CascadeType.ALL)
    private List<Friend> requestList = new ArrayList<>();


    public static Account createAccount(AccountAutoDto dto) {
        StringBuilder randomCode = new StringBuilder();
        for (int i =1; i<=4;i++) {
            int n = (int) (Math.random() * 10);
            randomCode.append(n);
        }

        return Account.builder()
                .email(dto.getEmail())
                .password(dto.getPassword())
                .name(dto.getName())
                .code(String.valueOf(randomCode))
                .status(Status.VALID)
                .roleType(RoleType.ROLE_USER)
                .build();
    }
    public void changeRole(RoleType roleType) {
        this.roleType = roleType;
    }

}
