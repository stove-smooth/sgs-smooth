package com.example.chatserver.client;

import org.springframework.cloud.openfeign.FeignClient;

@FeignClient(name = "UserFeign", url = "http://localhost:8088/presence-server")
public interface PresenceClient {
}
