package com.example.chatserver.controller;

import com.example.chatserver.domain.DirectChat;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@Slf4j
@RestController
@RequestMapping(value = "chat-server")
@RequiredArgsConstructor
public class ChatController {


    private final String topicName = "chat-server-topic";

    private final KafkaTemplate<String, DirectChat> kafkaTemplate;

    @PostMapping("/publish")
    public void sendMessage(@RequestBody DirectChat directChat) {
        log.info("Produce message :" + directChat.toString());
        try {
            kafkaTemplate.send(topicName, directChat).get();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @MessageMapping("/sendMessage")
    @SendTo("/topic/group")
    public DirectChat sendMessage2(@Payload DirectChat directChat) {
        return directChat;
    }
}
