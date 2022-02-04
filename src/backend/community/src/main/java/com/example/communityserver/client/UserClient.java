package com.example.communityserver.client;

import com.example.communityserver.dto.response.UserInfoFeignResponse;
import com.example.communityserver.dto.response.UserInfoListFeignResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;

import java.util.List;


@FeignClient(name = "UserFeign", url = "http://52.79.229.100:8000/auth-server")
public interface UserClient {

    String AUTHORIZATION = "AUTHORIZATION";

    @GetMapping("/auth/info")
    UserInfoFeignResponse getUserInfo(@RequestHeader(AUTHORIZATION) String token);

    @PostMapping("/find-id-list")
    UserInfoListFeignResponse getUserInfoList(@RequestHeader(AUTHORIZATION) String token, @RequestBody List<Long> ids);

}
