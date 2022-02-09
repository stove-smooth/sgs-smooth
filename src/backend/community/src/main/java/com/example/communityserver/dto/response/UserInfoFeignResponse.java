package com.example.communityserver.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UserInfoFeignResponse extends CommonResponse {

    private UserInfoResponse result;

    @Getter
    public static class UserInfoResponse {
        private String email;
        private String name;
        private String code;
        private String bio;
        private String profileImage;
    }
}
