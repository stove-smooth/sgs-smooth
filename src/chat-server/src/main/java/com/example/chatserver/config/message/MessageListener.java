package com.example.chatserver.config.message;

import com.example.chatserver.client.CommunityClient;
import com.example.chatserver.client.PresenceClient;
import com.example.chatserver.client.UserClient;
import com.example.chatserver.domain.ChannelMessage;
import com.example.chatserver.domain.DirectChat;
import com.example.chatserver.dto.response.CommunityFeignResponse;
import com.example.chatserver.dto.response.UserInfoFeignResponse;
import com.example.chatserver.repository.ChannelMessageRepository;
import com.example.chatserver.repository.DirectChatRepository;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@Slf4j
@Component
@RequiredArgsConstructor
public class MessageListener {


    private final String topicNameForDirect = "chat-server-topic";
    private final String topicNameForChannel = "channel-server-topic";
    private final String groupName = "chat-server-group";

    private final ObjectMapper objectMapper;
    private final SimpMessagingTemplate template;
    private final DirectChatRepository directChatRepository;
    private final UserClient userClient;
    private final ChannelMessageRepository channelChatRepository;
    private final RedisTemplate<String, UserInfoFeignResponse.UserInfoResponse> redisTemplate;
    private final RedisTemplate<String, CommunityFeignResponse.UserIdResponse> redisTemplateForIds;
    private final PresenceClient presenceClient;
    private final CommunityClient communityClient;
//    private final NotificationClient notificationClient;
//    private final TcpClientGateway tcpClientGateway;

    // 레디스 채팅 저장 시간 5분
    private long TIME = 5 * 60 * 1000L;

    @KafkaListener(topics = topicNameForDirect, groupId = groupName)
    public void listen(DirectChat directChat) throws JsonProcessingException {
        HashMap<String,String> msg = new HashMap<>();
        log.info(directChat.getContent());

        Object user_key = redisTemplate.opsForValue().get("USER" + directChat.getUserId());
        if (user_key == null) {
            UserInfoFeignResponse userInfo = userClient.getUserInfo(directChat.getUserId());
            redisTemplate.opsForValue().set("USER"+directChat.getUserId(),userInfo.getResult(),TIME,TimeUnit.MILLISECONDS);
            msg.put("userId", String.valueOf(directChat.getUserId()));
            msg.put("name",userInfo.getResult().getName());
            msg.put("profileImage",userInfo.getResult().getProfileImage());
            msg.put("message",directChat.getContent());
            msg.put("time", String.valueOf(directChat.getLocalDateTime()));
        } else {
            UserInfoFeignResponse.UserInfoResponse userInfoResponse = objectMapper.convertValue(user_key, new TypeReference<>() {
            });
            msg.put("userId", String.valueOf(directChat.getUserId()));
            msg.put("name", userInfoResponse.getName());
            msg.put("profileImage", userInfoResponse.getProfileImage());
            msg.put("message",directChat.getContent());
            msg.put("time", String.valueOf(directChat.getLocalDateTime()));
        }
        DirectChat save = directChatRepository.save(directChat);
        msg.put("id",save.getId());
        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(msg);
        
        template.convertAndSend("/topic/direct/" + directChat.getChannelId(), json);
    }

    @KafkaListener(topics = topicNameForChannel, groupId = groupName)
    public void listen2(ChannelMessage channelMessage) throws JsonProcessingException {
        HashMap<String,String> msg = new HashMap<>();
        log.info(channelMessage.getContent());

        Object user_key = redisTemplate.opsForValue().get("USER" + channelMessage.getAccountId());
        if (user_key == null) {
            UserInfoFeignResponse userInfo = userClient.getUserInfo(channelMessage.getAccountId());
            redisTemplate.opsForValue().set("USER"+channelMessage.getAccountId(),userInfo.getResult(),TIME,TimeUnit.MILLISECONDS);
            msg.put("userId", String.valueOf(channelMessage.getAccountId()));
            msg.put("name",userInfo.getResult().getName());
            msg.put("profileImage",userInfo.getResult().getProfileImage());
            msg.put("message",channelMessage.getContent());
            msg.put("time", String.valueOf(channelMessage.getLocalDateTime()));
        } else {
            UserInfoFeignResponse.UserInfoResponse userInfoResponse = objectMapper.convertValue(user_key, new TypeReference<>() {
            });
            msg.put("userId", String.valueOf(channelMessage.getAccountId()));
            msg.put("name", userInfoResponse.getName());
            msg.put("profileImage", userInfoResponse.getProfileImage());
            msg.put("message",channelMessage.getContent());
            msg.put("time", String.valueOf(channelMessage.getLocalDateTime()));
        }

//        Object Channel_key = redisTemplate.opsForValue().get("CH" + channelMessage.getChannelId());
//        if (Channel_key == null) {
//            CommunityFeignResponse userIds = communityClient.getUserIds(channelMessage.getChannelId());
//            redisTemplateForIds.opsForValue().set("CH"+ channelMessage.getChannelId(),userIds.getResult(),TIME,TimeUnit.MILLISECONDS);
//            Map<Long, Boolean> readCheck = presenceClient.read(userIds.getResult().getMembers());
//            channelMessage.setRead(readCheck);
//        } else {
//            CommunityFeignResponse.UserIdResponse userIdResponse = objectMapper.convertValue(Channel_key, new TypeReference<>() {
//            });
//            Map<Long, Boolean> readCheck = presenceClient.read(userIdResponse.getMembers());
//            channelMessage.setRead(readCheck);
//        }

//        RequestPushMessage request = RequestPushMessage
//                .builder()
//                .title("방이름")
//                .body(msg.get("name") + ":" + msg.get("message")).build();
//
//        notificationClient.notificationTopics("/topic/group",request);
        ChannelMessage save = channelChatRepository.save(channelMessage);
        msg.put("id",save.getId());
        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(msg);

        template.convertAndSend("/topic/group/" + channelMessage.getChannelId(), json);
    }
}
