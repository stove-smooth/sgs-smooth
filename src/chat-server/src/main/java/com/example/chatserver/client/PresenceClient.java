package com.example.chatserver.client;

import com.example.chatserver.dto.request.LoginSessionRequest;
import com.example.chatserver.dto.response.PresenceInfoFeignResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.List;
import java.util.Map;

//@FeignClient(name = "PresenceFeign", url = "http://52.79.229.100:8000/presence-server")
@FeignClient(name = "PresenceFeign", url = "http://localhost:8000/presence-server")
public interface PresenceClient {
    @PostMapping("/login-state")
    PresenceInfoFeignResponse uploadState(@RequestBody LoginSessionRequest loginSessionRequest);

    @PostMapping("/logout-state")
    PresenceInfoFeignResponse deleteState(@RequestBody LoginSessionRequest loginSessionRequest);

    @PostMapping("/change-state")
    PresenceInfoFeignResponse changeState(@RequestBody LoginSessionRequest loginSessionRequest);

    @PostMapping("/read")
    Map<Long,Boolean> read(@RequestBody List<Long> requestAccountIds);
}
