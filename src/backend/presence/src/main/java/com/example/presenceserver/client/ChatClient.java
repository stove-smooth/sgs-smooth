package com.example.presenceserver.client;

import com.example.presenceserver.dto.request.SignalingRequest;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;


@FeignClient(name = "ChatFeign", url = "http://52.79.229.100:8000/chat-server")
public interface ChatClient {

    @PostMapping("/signaling-list-community")
    void getSignalingListForCommunity(@RequestBody SignalingRequest signalingRequest);

    @PostMapping("/signaling-list-direct")
    void getSignalingListForDirect(@RequestBody SignalingRequest signalingRequest);

}

