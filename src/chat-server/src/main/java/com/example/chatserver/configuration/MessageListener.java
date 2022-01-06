package com.example.chatserver.configuration;

import com.example.chatserver.domain.DirectChat;
import com.example.chatserver.repository.MessageRepository;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;

import java.util.HashMap;

@Slf4j
@Component
@RequiredArgsConstructor
public class MessageListener {


    private final String topicName = "chat-server-topic";
    private final String groupName = "chat-server-group";

    private final SimpMessagingTemplate template;
    private final MessageRepository messageRepository;

    @KafkaListener(topics = topicName, groupId = groupName)
    public void listen(DirectChat directChat) throws JsonProcessingException {
        messageRepository.save(directChat);
        HashMap<String,String> msg = new HashMap<>();
        msg.put("name","병찬");
        msg.put("message",directChat.getContent());
        msg.put("time", String.valueOf(directChat.getDateTime()));

        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(msg);

        template.convertAndSend("/topic/group", json);
    }
}
