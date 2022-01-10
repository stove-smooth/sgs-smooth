package com.example.communityserver.client;

import com.example.communityserver.dto.response.UserInfoFeignResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;


@FeignClient(name = "UserFeign", url = "http://3.38.10.189:8000/auth-server/auth")
public interface UserClient {

    @GetMapping("/info")
    UserInfoFeignResponse getUserInfo(@RequestHeader("AUTHORIZATION") String token);
}
