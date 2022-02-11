package com.example.chatserver.client;

import com.example.chatserver.dto.request.ChannelNotiRequest;
import com.example.chatserver.dto.request.DirectNotiRequest;
import com.example.chatserver.dto.request.RequestPushMessage;
import com.example.chatserver.dto.response.CommonResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient(name = "NotificationFeign", url = "http://3.39.28.108:8080/notification-server")
public interface NotificationClient {


    @PostMapping("/direct")
    CommonResponse directNoti(@RequestBody DirectNotiRequest directNotiRequest);

    @PostMapping("/channel")
    CommonResponse channelNoti(@RequestBody ChannelNotiRequest channelNotiRequest);
}
