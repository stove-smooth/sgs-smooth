package com.example.chatserver.controller;

import com.example.chatserver.configuration.MessageSender;
import com.example.chatserver.domain.DirectChat;
import com.example.chatserver.dto.request.DirectChatRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;


@Slf4j
@RestController
@RequestMapping(value = "chat-server")
@RequiredArgsConstructor
public class ChatController {

    private final String topicName = "chat-server-topic";

    private final MessageSender messageSender;

    @MessageMapping("/send-message")
//    @SendTo("/topic/group")
    public void sendMessage(@Payload DirectChat directChat) {
        directChat.setDateTime(LocalDateTime.now());
        messageSender.send(topicName,directChat);
    }
//    @MessageMapping("/file")
//    @SendTo("/topic/group")
//    public void sendFile(@Payload DirectChatRequest request) {
//        DirectChat directChat = DirectChat.builder()
//                .content(request.getContent())
//    }
}
