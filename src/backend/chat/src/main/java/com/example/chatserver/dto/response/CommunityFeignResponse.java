package com.example.chatserver.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class CommunityFeignResponse extends CommonResponse{
    private UserIdResponse result;

    @Getter
    @Setter
    @AllArgsConstructor
    @NoArgsConstructor
    public static class UserIdResponse {
        private List<Long> members;
    }
}
