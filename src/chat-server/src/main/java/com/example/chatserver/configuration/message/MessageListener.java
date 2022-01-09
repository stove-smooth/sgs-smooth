package com.example.chatserver.configuration.message;

import com.example.chatserver.domain.ChannelMessage;
import com.example.chatserver.domain.DirectChat;
import com.example.chatserver.repository.ChannelChatRepository;
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
    private final String topicName2 = "channel-server-topic";
    private final String groupName = "chat-server-group";

    private final SimpMessagingTemplate template;
    private final MessageRepository messageRepository;

    private final ChannelChatRepository channelChatRepository;

    @KafkaListener(topics = topicName, groupId = groupName)
    public void listen(DirectChat directChat) throws JsonProcessingException {
        log.info("pass");
        messageRepository.save(directChat);

        HashMap<String,String> msg = new HashMap<>();
        msg.put("name","병찬");
        msg.put("message",directChat.getContent());
        msg.put("time", String.valueOf(directChat.getDateTime()));

        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(msg);

        template.convertAndSend("/topic/group", json);
    }

    @KafkaListener(topics = topicName2, groupId = groupName)
    public void listen2(ChannelMessage channelMessage) throws JsonProcessingException {

        channelChatRepository.save(channelMessage);
        HashMap<String,String> msg = new HashMap<>();
        msg.put("name","병찬");
        msg.put("message",channelMessage.getContent());
        msg.put("time", String.valueOf(channelMessage.getLocalDateTime()));

        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(msg);

        template.convertAndSend("/topic/group", json);
    }
}
