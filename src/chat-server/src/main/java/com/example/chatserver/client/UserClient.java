package com.example.chatserver.client;

import com.example.chatserver.dto.response.UserInfoFeignResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@FeignClient(name = "UserFeign", url = "http://52.79.229.100:8000/auth-server")
public interface UserClient {

    @GetMapping("/name")
    UserInfoFeignResponse getUserInfo(@RequestParam(value = "id") Long id);
}
