package com.example.chatserver.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class UserInfoFeignResponse extends CommonResponse {

    private UserInfoResponse result;

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor
    public static class UserInfoResponse {
        private String name;
        private String profileImage;
    }
}
