package com.example.chatserver.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Map;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class UserInfoListFeignResponse extends CommonResponse{

    private Map<Long,UserResponse> result;
}
