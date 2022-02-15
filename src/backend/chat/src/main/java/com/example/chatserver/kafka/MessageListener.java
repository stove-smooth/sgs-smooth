package com.example.chatserver.kafka;

import com.example.chatserver.client.CommunityClient;
import com.example.chatserver.client.NotificationClient;
import com.example.chatserver.client.PresenceClient;
import com.example.chatserver.client.UserClient;
import com.example.chatserver.config.TcpClientGateway;
import com.example.chatserver.domain.ChannelMessage;
import com.example.chatserver.domain.DirectMessage;
import com.example.chatserver.dto.request.ChannelNotiRequest;
import com.example.chatserver.dto.request.DirectNotiRequest;
import com.example.chatserver.dto.request.LoginSessionRequest;
import com.example.chatserver.dto.response.CommunityFeignResponse;
import com.example.chatserver.dto.response.FileUploadResponse;
import com.example.chatserver.dto.response.UserInfoFeignResponse;
import com.example.chatserver.exception.CustomException;
import com.example.chatserver.exception.CustomExceptionStatus;
import com.example.chatserver.repository.ChannelMessageRepository;
import com.example.chatserver.repository.DirectMessageRepository;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.concurrent.TimeUnit;

@Slf4j
@Component
@RequiredArgsConstructor
public class MessageListener {


    private final String topicNameForDirect = "chat-server-topic";
    private final String topicNameForDirectEtc = "etc-direct-topic";
    private final String topicNameForCommunity = "channel-server-topic";
    private final String topicNameForCommunityEtc = "etc-community-topic";
    private final String topicForFileUpload = "file-topic";

    private final String directGroup = "direct-server-group1";
    private final String directETCGroup = "direct-etc-server-group1";
    private final String channelGroup = "channel-server-group1";
    private final String channelETCGroup = "channel-etc-server-group1";
    private final String fileGroup = "file-server-group1";

    private final ObjectMapper objectMapper;
    private final SimpMessagingTemplate template;

    @KafkaListener(topics = topicNameForDirect, groupId = directGroup, containerFactory = "directFactory")
    public void directMessageListener(DirectMessage directChat) throws JsonProcessingException {
        HashMap<String,String> msg = new HashMap<>();
        msg.put("type","message");
        msg.put("userId", String.valueOf(directChat.getUserId()));
        msg.put("name",directChat.getName());
        msg.put("profileImage",directChat.getProfileImage());
        msg.put("message",directChat.getContent());
        msg.put("time", String.valueOf(directChat.getLocalDateTime()));
        msg.put("id",directChat.getId());

        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(msg);
        template.convertAndSend("/topic/direct/" + directChat.getChannelId(), json);
        template.convertAndSend("/topic/user/" + directChat.getUserId(),json);
    }

    @KafkaListener(topics = topicNameForDirectEtc,groupId = directETCGroup, containerFactory = "directETCFactory")
    public void directEctListener(DirectMessage result) throws JsonProcessingException {
        HashMap<String,String> msg = new HashMap<>();

        switch (result.getType()) {
            case "typing":
                msg.put("type","typing");
                msg.put("name", result.getContent());
                break;
            case "reply": {
                msg.put("type","reply");
                msg.put("id", result.getId());
                msg.put("userId", String.valueOf(result.getUserId()));
                msg.put("name", result.getName());
                msg.put("profileImage", result.getProfileImage());
                msg.put("message", result.getContent());
                msg.put("time", String.valueOf(result.getLocalDateTime()));
                msg.put("parentName", result.getParentName());
                msg.put("parentContent", result.getParentContent());
                ObjectMapper mapper = new ObjectMapper();
                String json = mapper.writeValueAsString(msg);
                template.convertAndSend("/topic/user/" + result.getUserId(),json);

                break;
            }
            case "modify": {
                msg.put("type","modify");
                msg.put("id", result.getId());
                msg.put("userId", String.valueOf(result.getUserId()));
                msg.put("message", result.getContent());
                msg.put("time", String.valueOf(result.getLocalDateTime()));

                break;
            }
            case "delete": {
                msg.put("type","delete");
                msg.put("id", result.getId());

                break;
            }
        }

        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(msg);

        template.convertAndSend("/topic/direct/" + result.getChannelId(), json);
    }

    @KafkaListener(topics = topicNameForCommunity, groupId = channelGroup, containerFactory = "communityFactory")
    public void communityChatListener(ChannelMessage channelMessage) throws JsonProcessingException {
        HashMap<String,String> msg = new HashMap<>();

        msg.put("type","message");
        msg.put("userId", String.valueOf(channelMessage.getUserId()));
        msg.put("name",channelMessage.getName());
        msg.put("profileImage",channelMessage.getProfileImage());
        msg.put("message",channelMessage.getContent());
        msg.put("time", String.valueOf(channelMessage.getLocalDateTime()));
        msg.put("id",channelMessage.getId());
        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(msg);

        template.convertAndSend("/topic/group/" + channelMessage.getChannelId(), json);
    }

    @KafkaListener(topics = topicNameForCommunityEtc,groupId = channelETCGroup, containerFactory = "ChannelETCFactory")
    public void CommunityEctListener(ChannelMessage result) throws JsonProcessingException {
        HashMap<String,String> msg = new HashMap<>();

        switch (result.getType()) {
            case "typing":
                msg.put("type","typing");
                msg.put("name", result.getContent());
                break;
            case "reply": {
                msg.put("type","reply");
                msg.put("id", result.getId());
                msg.put("userId", String.valueOf(result.getUserId()));
                msg.put("name", result.getName());
                msg.put("profileImage", result.getProfileImage());
                msg.put("message", result.getContent());
                msg.put("time", String.valueOf(result.getLocalDateTime()));
                msg.put("parentName", result.getParentName());
                msg.put("parentContent", result.getParentContent());

                break;
            }
            case "modify": {
                msg.put("type","modify");
                msg.put("id", result.getId());
                msg.put("userId", String.valueOf(result.getUserId()));
                msg.put("message", result.getContent());
                msg.put("time", String.valueOf(result.getLocalDateTime()));

                break;
            }
            case "delete": {
                msg.put("type","delete");
                msg.put("id", result.getId());
                break;
            }
        }

        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(msg);

        template.convertAndSend("/topic/group/" + result.getChannelId(), json);
    }

    @KafkaListener(topics = topicForFileUpload,groupId = fileGroup, containerFactory = "kafkaListenerContainerFactoryForFile")
    public void fileUpload(FileUploadResponse fileUploadResponse) throws IOException {
        if (fileUploadResponse.getType().equals("direct")) {
            String json = objectMapper.writeValueAsString(fileUploadResponse);
            template.convertAndSend("/topic/user/" + fileUploadResponse.getUserId(),json);
            template.convertAndSend("/topic/direct/" + fileUploadResponse.getChannelId(), json);
        } else {
            String json = objectMapper.writeValueAsString(fileUploadResponse);
            template.convertAndSend("/topic/group/" + fileUploadResponse.getChannelId(), json);
        }
    }
}
