package com.example.chatserver.configuration;

import com.example.chatserver.domain.DirectChat;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class MessageSender {

    private final KafkaTemplate<String,DirectChat> kafkaTemplate;

    public void send(String topic, DirectChat directChat) {
        kafkaTemplate.send(topic,directChat);
    }
}
