package com.example.chatserver.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class CommunityFeignResponse extends CommonResponse{
    private UserIdResponse result;

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor
    public static class UserIdResponse {
        private List<Long> members;
    }
}
