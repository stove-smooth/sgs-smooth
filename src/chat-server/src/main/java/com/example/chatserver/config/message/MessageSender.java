package com.example.chatserver.config.message;

import com.example.chatserver.domain.ChannelMessage;
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

    private final KafkaTemplate<String, ChannelMessage> kafkaTemplate2;

    public void send(String topic, DirectChat directChat) {
        kafkaTemplate.send(topic,directChat);
    }

    public void send2(String topic,ChannelMessage channelMessage) {
        kafkaTemplate2.send(topic,channelMessage);
    }
}
