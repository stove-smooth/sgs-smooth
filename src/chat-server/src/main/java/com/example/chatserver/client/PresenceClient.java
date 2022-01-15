package com.example.chatserver.client;

import com.example.chatserver.dto.request.LoginSessionRequest;
import com.example.chatserver.dto.response.PresenceInfoFeignResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient(name = "UserFeign", url = "http://localhost:8088/presence-server")
public interface PresenceClient {

    @PostMapping("/login-state")
    PresenceInfoFeignResponse uploadState(@RequestBody LoginSessionRequest loginSessionRequest);

    @PostMapping("/logout-state")
    PresenceInfoFeignResponse deleteState(@RequestBody LoginSessionRequest loginSessionRequest);
}
