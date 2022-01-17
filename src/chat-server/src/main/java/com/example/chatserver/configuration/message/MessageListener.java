package com.example.chatserver.configuration.message;

import com.example.chatserver.client.UserClient;
import com.example.chatserver.domain.ChannelMessage;
import com.example.chatserver.domain.DirectChat;
import com.example.chatserver.dto.response.UserInfoFeignResponse;
import com.example.chatserver.repository.ChannelChatRepository;
import com.example.chatserver.repository.MessageRepository;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Component
@RequiredArgsConstructor
public class MessageListener {


    private final String topicName = "chat-server-topic";
    private final String topicName2 = "channel-server-topic";
    private final String groupName = "chat-server-group";

    private final SimpMessagingTemplate template;
    private final MessageRepository messageRepository;
    private final UserClient userClient;
    private final ChannelChatRepository channelChatRepository;
    private final RedisTemplate<String, Object> redisTemplate;

    @KafkaListener(topics = topicName, groupId = groupName)
    public void listen(DirectChat directChat) throws JsonProcessingException {
        List<Long> ids = directChat.getIds();
        Map<Long,Boolean> check = new HashMap<>();
        for (Long i : ids) {
            if (redisTemplate.opsForValue().get(String.valueOf(i)) == null) {
                check.put(i,false);
            } else {
                check.put(i,true);
            }
        }
        directChat.setRead(check);
        messageRepository.save(directChat);
        UserInfoFeignResponse userInfo = userClient.getUserInfo(directChat.getUser_id());
        HashMap<String,String> msg = new HashMap<>();
        msg.put("name",userInfo.getResult().getName());
        msg.put("profileImage",userInfo.getResult().getProfileImage());
        msg.put("message",directChat.getContent());
        msg.put("time", String.valueOf(directChat.getDateTime()));

        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(msg);

        template.convertAndSend("/topic/group", json);
    }

    @KafkaListener(topics = topicName2, groupId = groupName)
    public void listen2(ChannelMessage channelMessage) throws JsonProcessingException {

        List<Long> ids = channelMessage.getIds();
        Map<Long,Boolean> check = new HashMap<>();
        for (Long i : ids) {
            if (redisTemplate.opsForValue().get(String.valueOf(i)) == null) {
                check.put(i,false);
            } else {
                check.put(i,true);
            }
        }
        channelMessage.setRead(check);
        channelChatRepository.save(channelMessage);
        HashMap<String,String> msg = new HashMap<>();
        UserInfoFeignResponse userInfo = userClient.getUserInfo(channelMessage.getAccount_id());
        msg.put("name",userInfo.getResult().getName());
        msg.put("profileImage",userInfo.getResult().getProfileImage());
        msg.put("message",channelMessage.getContent());
        msg.put("time", String.valueOf(channelMessage.getLocalDateTime()));

        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(msg);

        template.convertAndSend("/topic/group", json);
    }
}
