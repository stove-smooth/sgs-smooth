package com.example.communityserver.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import java.util.concurrent.ConcurrentMap;

@FeignClient(name = "PresenceFeign", url = "http://15.165.252.177:8088/presence-server")
public interface PresenceClient {

    @GetMapping("/user-state")
    ConcurrentMap<Long, String> getUserState();
}
