package com.example.chatserver.client;

import com.example.chatserver.dto.request.LoginSessionRequest;
import com.example.chatserver.dto.response.PresenceInfoFeignResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.List;
import java.util.Map;

@FeignClient(name = "PresenceFeign", url = "http://localhost:8088/presence-server")
public interface PresenceClient {
    @PostMapping("/login-state")
    PresenceInfoFeignResponse uploadState(@RequestBody LoginSessionRequest loginSessionRequest);

    @PostMapping("/logout-state")
    PresenceInfoFeignResponse deleteState(@RequestBody LoginSessionRequest loginSessionRequest);

    @PostMapping("/read")
    Map<Long,Boolean> read(@RequestBody List<Long> requestAccountIds);
}
