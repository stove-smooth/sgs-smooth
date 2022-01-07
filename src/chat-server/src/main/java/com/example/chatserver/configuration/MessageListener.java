package com.example.chatserver.configuration;

import com.example.chatserver.domain.DirectChat;
import com.example.chatserver.dto.request.DirectChatRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class MessageListener {

    private final SimpMessagingTemplate template;

    private final String topicName = "chat-server-topic";

    private final String groupName = "chat-server-group";

    @KafkaListener(topics = topicName, groupId = groupName)
    public void listen(DirectChat directChat) {
        log.info("sending via kafka listener .. ");
        log.info(directChat.toString());
        template.convertAndSend("/topic/group", directChat);
    }
}
