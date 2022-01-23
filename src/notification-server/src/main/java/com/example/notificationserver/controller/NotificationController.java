package com.example.notificationserver.controller;

import com.example.notificationserver.dto.request.RequestPushMessage;
import com.example.notificationserver.service.FcmService;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@Slf4j
@RestController
@RequestMapping("/notification-server")
@RequiredArgsConstructor
public class NotificationController {

    private final FcmService fcmService;

    @Value("${fcm.firebase-multicast-message-size}")
    private Long multicastMessageSize;

    @PostMapping("/pushs/topics/{topic}")
    public void notificationTopics(@PathVariable("topic") String topic, @RequestBody RequestPushMessage data) throws FirebaseMessagingException {
        Notification notification = Notification.builder().setTitle(data.getTitle()).setBody(data.getBody()).setImage(data.getImage()).build();
        Message.Builder builder = Message.builder();
        Optional.ofNullable(data.getData()).ifPresent(sit -> builder.putAllData(sit));
        Message msg = builder.setTopic(topic).setNotification(notification).build();
        fcmService.sendMessage(msg);
    }
}
