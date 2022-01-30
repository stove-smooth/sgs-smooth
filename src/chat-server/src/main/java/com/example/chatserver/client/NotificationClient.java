package com.example.chatserver.client;

import com.example.chatserver.dto.request.RequestPushMessage;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient(name = "NotificationFeign", url = "http://localhost:8000/community-server")
public interface NotificationClient {

    @PostMapping("/pushs/topics/{topic}")
    String notificationTopics(@PathVariable("topic") String topic, @RequestBody RequestPushMessage data);
}
