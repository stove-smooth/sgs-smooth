package com.example.chatserver.configuration.message;

import com.example.chatserver.client.CommunityClient;
import com.example.chatserver.client.PresenceClient;
import com.example.chatserver.client.UserClient;
import com.example.chatserver.configuration.TcpClientGateway;
import com.example.chatserver.domain.ChannelMessage;
import com.example.chatserver.domain.DirectChat;
import com.example.chatserver.dto.response.CommunityFeignResponse;
import com.example.chatserver.dto.response.UserInfoFeignResponse;
import com.example.chatserver.repository.ChannelChatRepository;
import com.example.chatserver.repository.MessageRepository;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@Slf4j
@Component
@RequiredArgsConstructor
public class MessageListener {


    private final String topicName = "chat-server-topic";
    private final String topicName2 = "channel-server-topic";
    private final String groupName = "chat-server-group";

    private final ObjectMapper objectMapper;
    private final SimpMessagingTemplate template;
    private final MessageRepository messageRepository;
    private final UserClient userClient;
    private final ChannelChatRepository channelChatRepository;
    private final RedisTemplate<String, UserInfoFeignResponse.UserInfoResponse> redisTemplate;
    private final RedisTemplate<String, CommunityFeignResponse.UserIdResponse> redisTemplateForIds;
    private final PresenceClient presenceClient;
    private final CommunityClient communityClient;
    private final TcpClientGateway tcpClientGateway;

    // 레디스 채팅 저장 시간 5분
    private long TIME = 5 * 60 * 1000L;

    @KafkaListener(topics = topicName, groupId = groupName)
    public void listen(DirectChat directChat) throws JsonProcessingException {
//        directChat.setRead(read);
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
        HashMap<String,String> msg = new HashMap<>();

        if (redisTemplate.opsForValue().get(String.valueOf(channelMessage.getAccount_id())) == null) {
            UserInfoFeignResponse userInfo = userClient.getUserInfo(channelMessage.getAccount_id());
            redisTemplate.opsForValue().set(String.valueOf(channelMessage.getAccount_id()),userInfo.getResult(),TIME,TimeUnit.MILLISECONDS);
            msg.put("name",userInfo.getResult().getName());
            msg.put("profileImage",userInfo.getResult().getProfileImage());
            msg.put("message",channelMessage.getContent());
            msg.put("time", String.valueOf(channelMessage.getLocalDateTime()));
        } else {
            UserInfoFeignResponse.UserInfoResponse userInfoResponse = objectMapper.convertValue(redisTemplate.opsForValue().get(String.valueOf(channelMessage.getAccount_id())), new TypeReference<>() {
            });
            msg.put("name", userInfoResponse.getName());
            msg.put("profileImage", userInfoResponse.getProfileImage());
            msg.put("message",channelMessage.getContent());
            msg.put("time", String.valueOf(channelMessage.getLocalDateTime()));
        }

        if (redisTemplate.opsForValue().get(String.valueOf(channelMessage.getCommunity_id())) == null) {
            CommunityFeignResponse userIds = communityClient.getUserIds(channelMessage.getCommunity_id());
            redisTemplateForIds.opsForValue().set(String.valueOf(channelMessage.getCommunity_id()),userIds.getResult(),TIME,TimeUnit.MILLISECONDS);
            Map<Long, Boolean> readCheck = presenceClient.read(userIds.getResult().getMembers());
            channelMessage.setRead(readCheck);
        } else {
            CommunityFeignResponse.UserIdResponse userIdResponse = objectMapper.convertValue(redisTemplateForIds.opsForValue().get(String.valueOf(channelMessage.getCommunity_id())), new TypeReference<>() {
            });
            Map<Long, Boolean> readCheck = presenceClient.read(userIdResponse.getMembers());
            channelMessage.setRead(readCheck);
        }

        channelChatRepository.save(channelMessage);
        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(msg);

        template.convertAndSend("/topic/group", json);
    }
}
