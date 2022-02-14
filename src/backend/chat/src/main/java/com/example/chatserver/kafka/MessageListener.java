package com.example.chatserver.kafka;

import com.example.chatserver.client.CommunityClient;
import com.example.chatserver.client.NotificationClient;
import com.example.chatserver.client.PresenceClient;
import com.example.chatserver.client.UserClient;
import com.example.chatserver.config.TcpClientGateway;
import com.example.chatserver.domain.ChannelMessage;
import com.example.chatserver.domain.DirectMessage;
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
    private final DirectMessageRepository directChatRepository;
    private final ChannelMessageRepository channelChatRepository;
    private final RedisTemplate<String, CommunityFeignResponse.UserIdResponse> redisTemplateForIds;
    private final CommunityClient communityClient;
    private final TcpClientGateway tcpClientGateway;
    private final NotificationClient notificationClient;

    // 레디스 채팅 저장 시간 2주
    private long TIME = 14 * 24 * 60 * 60 * 1000L;

    @KafkaListener(topics = topicNameForDirect, groupId = directGroup, containerFactory = "directFactory")
    public void directMessageListener(DirectMessage directChat) throws JsonProcessingException {
        HashMap<String,String> msg = new HashMap<>();
        msg.put("type","message");
        msg.put("userId", String.valueOf(directChat.getUserId()));
        msg.put("name",directChat.getName());
        msg.put("profileImage",directChat.getProfileImage());
        msg.put("message",directChat.getContent());
        msg.put("time", String.valueOf(directChat.getLocalDateTime()));

        Object Community_key = redisTemplateForIds.opsForValue().get("R" + directChat.getChannelId());
        String send;
        if (Community_key == null) {
            // 커뮤니티에 속해 있는 유저 id값 반환
            CommunityFeignResponse userIds = communityClient.getUserIdsFromDM(directChat.getChannelId());
            redisTemplateForIds.opsForValue().set("R"+ directChat.getChannelId(),userIds.getResult(),TIME,TimeUnit.MILLISECONDS);
            LoginSessionRequest loginSessionRequest = LoginSessionRequest.builder()
                    .type("direct")
                    .community_id("r-" + directChat.getChannelId())
                    .ids(userIds.getResult().getMembers()).build();
            send = tcpClientGateway.send(loginSessionRequest.toString());


        } else {
            CommunityFeignResponse.UserIdResponse userIdResponse = objectMapper.convertValue(Community_key, new TypeReference<>() {});
            LoginSessionRequest loginSessionRequest = LoginSessionRequest.builder()
                    .type("community")
                    .community_id("c-" + directChat.getChannelId())
                    .ids(userIdResponse.getMembers()).build();
            send = tcpClientGateway.send(loginSessionRequest.toString());
        }
//        DirectNotiRequest request = DirectNotiRequest.builder()
//                .userId(directChat.getUserId())
//                .username(directChat.getName())
//                .type("text")
//                .roomName("DM")
//                .content(directChat.getContent())
//                .roomId(directChat.getChannelId())
//                .target(send).build();
//        notificationClient.directNoti(request);

        DirectMessage save = directChatRepository.save(directChat);
        msg.put("id",save.getId());
        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(msg);
        template.convertAndSend("/topic/direct/" + directChat.getChannelId(), json);
    }

    @KafkaListener(topics = topicNameForDirectEtc,groupId = directETCGroup, containerFactory = "directETCFactory")
    public void directEctListener(DirectMessage directChat) throws JsonProcessingException {
        String type = directChat.getType();
        HashMap<String,String> msg = new HashMap<>();

        switch (type) {
            case "typing":
                msg.put("type","typing");
                msg.put("name", directChat.getContent());
                break;
            case "reply": {
                directChat.setLocalDateTime(LocalDateTime.now());
                DirectMessage result = directChatRepository.save(directChat);

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
                DirectMessage result = directChatRepository.findById(directChat.getId())
                        .orElseThrow(() -> new CustomException(CustomExceptionStatus.MESSAGE_NOT_FOUND));

                result.setContent(directChat.getContent());
                directChatRepository.save(result);

                msg.put("type","modify");
                msg.put("id", result.getId());
                msg.put("userId", String.valueOf(result.getUserId()));
                msg.put("message", result.getContent());
                msg.put("time", String.valueOf(result.getLocalDateTime()));

                break;
            }
            case "delete": {
                DirectMessage result = directChatRepository.findById(directChat.getId())
                        .orElseThrow(() -> new CustomException(CustomExceptionStatus.MESSAGE_NOT_FOUND));

                if (!result.getUserId().equals(directChat.getUserId())) {
                    throw new CustomException(CustomExceptionStatus.ACCOUNT_NOT_VALID);
                }

                directChatRepository.deleteById(result.getId());

                msg.put("type","delete");
                msg.put("id", result.getId());

                break;
            }
        }

        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(msg);

        template.convertAndSend("/topic/direct/" + directChat.getChannelId(), json);
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


        Object Community_key = redisTemplateForIds.opsForValue().get("CH" + channelMessage.getCommunityId());
        String send;
        if (Community_key == null) {
            // 커뮤니티에 속해 있는 유저 id값 반환
            CommunityFeignResponse userIds = communityClient.getUserIds(channelMessage.getCommunityId());
            redisTemplateForIds.opsForValue().set("CH"+ channelMessage.getCommunityId(),userIds.getResult(),TIME,TimeUnit.MILLISECONDS);
            LoginSessionRequest loginSessionRequest = LoginSessionRequest.builder()
                    .type("community")
                    .community_id("c-" + channelMessage.getChannelId())
                    .ids(userIds.getResult().getMembers()).build();
            send = tcpClientGateway.send(loginSessionRequest.toString());

        } else {
            CommunityFeignResponse.UserIdResponse userIdResponse = objectMapper.convertValue(Community_key, new TypeReference<>() {
            });
            LoginSessionRequest loginSessionRequest = LoginSessionRequest.builder()
                    .type("community")
                    .community_id("c-" + channelMessage.getChannelId())
                    .ids(userIdResponse.getMembers()).build();
            send = tcpClientGateway.send(loginSessionRequest.toString());
        }

//        ChannelNotiRequest request = ChannelNotiRequest.builder()
//                .userId(channelMessage.getUserId())
//                .username(channelMessage.getName())
//                .type("text")
//                .content(channelMessage.getContent())
//                .channelName("CHANNEL")
//                .communityId(channelMessage.getCommunityId())
//                .channelId(channelMessage.getChannelId())
//                .target(send).build();
//        notificationClient.channelNoti(request);

        ChannelMessage save = channelChatRepository.save(channelMessage);
        msg.put("id",save.getId());
        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(msg);

        template.convertAndSend("/topic/group/" + channelMessage.getChannelId(), json);
    }

    @KafkaListener(topics = topicNameForCommunityEtc,groupId = channelETCGroup, containerFactory = "ChannelETCFactory")
    public void CommunityEctListener(ChannelMessage channelMessage) throws JsonProcessingException {
        String type = channelMessage.getType();
        HashMap<String,String> msg = new HashMap<>();

        switch (type) {
            case "typing":
                msg.put("type","typing");
                msg.put("name", channelMessage.getContent());
                break;
            case "reply": {
                channelMessage.setLocalDateTime(LocalDateTime.now());
                ChannelMessage result = channelChatRepository.save(channelMessage);

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
                ChannelMessage result = channelChatRepository.findById(channelMessage.getId())
                        .orElseThrow(() -> new CustomException(CustomExceptionStatus.MESSAGE_NOT_FOUND));

                result.setContent(channelMessage.getContent());
                channelChatRepository.save(result);

                msg.put("type","modify");
                msg.put("id", result.getId());
                msg.put("userId", String.valueOf(result.getUserId()));
                msg.put("message", result.getContent());
                msg.put("time", String.valueOf(result.getLocalDateTime()));

                break;
            }
            case "delete": {
                ChannelMessage result = channelChatRepository.findById(channelMessage.getId())
                        .orElseThrow(() -> new CustomException(CustomExceptionStatus.MESSAGE_NOT_FOUND));

                if (!result.getUserId().equals(channelMessage.getUserId())) {
                    throw new CustomException(CustomExceptionStatus.ACCOUNT_NOT_VALID);
                }

                channelChatRepository.deleteById(channelMessage.getId());

                msg.put("type","delete");
                msg.put("id", result.getId());
                break;
            }
        }

        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(msg);

        template.convertAndSend("/topic/group/" + channelMessage.getChannelId(), json);
    }

    @KafkaListener(topics = topicForFileUpload,groupId = fileGroup, containerFactory = "kafkaListenerContainerFactoryForFile")
    public void fileUpload(FileUploadResponse fileUploadResponse) throws IOException {
        if (fileUploadResponse.getType().equals("direct")) {
            String json = objectMapper.writeValueAsString(fileUploadResponse);
            template.convertAndSend("/topic/direct/" + fileUploadResponse.getChannelId(), json);
        } else {
            String json = objectMapper.writeValueAsString(fileUploadResponse);
            template.convertAndSend("/topic/group/" + fileUploadResponse.getChannelId(), json);
        }
    }
}