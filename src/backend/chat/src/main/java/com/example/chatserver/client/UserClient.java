package com.example.chatserver.client;

import com.example.chatserver.dto.response.CommonResponse;
import com.example.chatserver.dto.response.UserInfoFeignResponse;
import com.example.chatserver.dto.response.UserInfoListFeignResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@FeignClient(name = "UserFeign", url = "https://api.yoloyolo.org/auth-server")
public interface UserClient {

    @GetMapping("/name")
    UserInfoFeignResponse getUserInfo(@RequestParam(value = "id") Long id);

    @PostMapping("/find-id-list")
    UserInfoListFeignResponse getUserInfoList(@RequestBody List<Long> ids);

    @PutMapping("/last-access")
    CommonResponse changeLastAccess(@RequestParam(value = "id") Long id);
}
