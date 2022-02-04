package com.example.authserver.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FriendResponse {

    private Long id;

    private Long userId;

    private String name;

    private String code;

    private String profileImage;

    private String state;

}
