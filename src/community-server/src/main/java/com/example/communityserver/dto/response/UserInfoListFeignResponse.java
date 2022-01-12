package com.example.communityserver.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.HashMap;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UserInfoListFeignResponse extends CommonResponse {

    private HashMap<Long, UserResponse> result;
}
