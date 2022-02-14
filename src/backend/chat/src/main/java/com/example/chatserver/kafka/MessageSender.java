package com.example.chatserver.kafka;

import com.example.chatserver.client.CommunityClient;
import com.example.chatserver.client.NotificationClient;
import com.example.chatserver.config.TcpClientGateway;
import com.example.chatserver.domain.ChannelMessage;
import com.example.chatserver.domain.DirectMessage;
import com.example.chatserver.dto.request.LoginSessionRequest;
import com.example.chatserver.dto.response.CommunityFeignResponse;
import com.example.chatserver.dto.response.FileUploadResponse;
import com.example.chatserver.exception.CustomException;
import com.example.chatserver.exception.CustomExceptionStatus;
import com.example.chatserver.repository.ChannelMessageRepository;
import com.example.chatserver.repository.DirectMessageRepository;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.concurrent.TimeUnit;

@Slf4j
@Component
@RequiredArgsConstructor
public class MessageSender {

    private final ObjectMapper objectMapper;
    private final DirectMessageRepository directChatRepository;
    private final ChannelMessageRepository channelChatRepository;
    private final RedisTemplate<String, CommunityFeignResponse.UserIdResponse> redisTemplateForIds;
    private final CommunityClient communityClient;
    private final TcpClientGateway tcpClientGateway;
    private final NotificationClient notificationClient;

    // 레디스 채팅 저장 시간 2주
    private long TIME = 14 * 24 * 60 * 60 * 1000L;

    private final KafkaTemplate<String, DirectMessage> kafkaTemplateForDirectMessage;

    private final KafkaTemplate<String, ChannelMessage> kafkaTemplateForChannelMessage;

    private final KafkaTemplate<String, FileUploadResponse> kafkaTemplateForFileUpload;

    public void sendToDirectChat(String topic, DirectMessage directChat) {
        Object Community_key = redisTemplateForIds.opsForValue().get("R" + directChat.getChannelId());
        String send;
        if (Community_key == null) {
            // 커뮤니티에 속해 있는 유저 id값 반환
            CommunityFeignResponse userIds = communityClient.getUserIdsFromDM(directChat.getChannelId());
            redisTemplateForIds.opsForValue().set("R"+ directChat.getChannelId(),userIds.getResult(),TIME, TimeUnit.MILLISECONDS);
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
        kafkaTemplateForDirectMessage.send(topic, save);
    }

    public void sendToChannelChat(String topic,ChannelMessage channelMessage) {
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
        kafkaTemplateForChannelMessage.send(topic,save);
    }

    public void sendToEtcDirectChat(String topic, DirectMessage directChat) {
        switch (directChat.getType()) {
            case "reply": {
                directChat.setLocalDateTime(LocalDateTime.now());
                DirectMessage result = directChatRepository.save(directChat);
                kafkaTemplateForDirectMessage.send(topic,result);
                break;
            }
            case "modify": {
                DirectMessage result = directChatRepository.findById(directChat.getId())
                        .orElseThrow(() -> new CustomException(CustomExceptionStatus.MESSAGE_NOT_FOUND));

                result.setContent(directChat.getContent());
                directChatRepository.save(result);
                kafkaTemplateForDirectMessage.send(topic,result);
                break;
            }
            case "delete": {
                DirectMessage result = directChatRepository.findById(directChat.getId())
                        .orElseThrow(() -> new CustomException(CustomExceptionStatus.MESSAGE_NOT_FOUND));

                if (!result.getUserId().equals(directChat.getUserId())) {
                    throw new CustomException(CustomExceptionStatus.ACCOUNT_NOT_VALID);
                }

                directChatRepository.deleteById(result.getId());
                kafkaTemplateForDirectMessage.send(topic,result);
                break;
            }
        }
    }
    public void sendToEtcChannelChat(String topic, ChannelMessage channelMessage) {
        switch (channelMessage.getType()) {
            case "reply": {
                channelMessage.setLocalDateTime(LocalDateTime.now());
                ChannelMessage result = channelChatRepository.save(channelMessage);
                kafkaTemplateForChannelMessage.send(topic,result);
                break;
            }
            case "modify": {
                ChannelMessage result = channelChatRepository.findById(channelMessage.getId())
                        .orElseThrow(() -> new CustomException(CustomExceptionStatus.MESSAGE_NOT_FOUND));

                result.setContent(channelMessage.getContent());
                channelChatRepository.save(result);
                kafkaTemplateForChannelMessage.send(topic,result);
                break;
            }
            case "delete": {
                ChannelMessage result = channelChatRepository.findById(channelMessage.getId())
                        .orElseThrow(() -> new CustomException(CustomExceptionStatus.MESSAGE_NOT_FOUND));

                if (!result.getUserId().equals(channelMessage.getUserId())) {
                    throw new CustomException(CustomExceptionStatus.ACCOUNT_NOT_VALID);
                }
                channelChatRepository.deleteById(channelMessage.getId());
                kafkaTemplateForChannelMessage.send(topic,result);
                break;
            }
        }
    }

    public void fileUpload(String topic, FileUploadResponse fileUploadResponse) {
        kafkaTemplateForFileUpload.send(topic,fileUploadResponse);
    }
}
