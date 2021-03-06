package com.example.chatserver.config;

import com.example.chatserver.client.CommunityClient;
import com.example.chatserver.dto.request.SignalingRequest;
import com.example.chatserver.dto.request.StateRequest;
import com.example.chatserver.kafka.JwtTokenFilter;
import com.example.chatserver.domain.MessageTime;
import com.example.chatserver.dto.request.LoginSessionRequest;
import com.example.chatserver.kafka.MessageSender;
import com.example.chatserver.repository.MessageTimeRepository;
import com.fasterxml.jackson.core.JsonProcessingException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;


@Slf4j
@RequiredArgsConstructor
@Component
public class FilterChannelInterceptor implements ChannelInterceptor {

    private final JwtTokenFilter jwtTokenFilter;
    private final TcpClientGateway tcpClientGateway;
    private final MessageTimeRepository messageTimeRepository;
    private final MessageSender messageSender;
    private final CommunityClient communityClient;

    @Value("${spring.kafka.consumer.state-topic}")
    private String stateTopic;

    @Override
    public Message<?> preSend(Message<?> message, MessageChannel channel) {
        StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(message);
        if (StompCommand.CONNECT.equals(headerAccessor.getCommand())) {
            if (!jwtTokenFilter.isJwtValid(Objects.requireNonNull(headerAccessor.getFirstNativeHeader("access-token")))) {
                log.info("??????");
                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
            }
        }

        return message;

    }

    @Override
    public void postSend(Message<?> message, MessageChannel channel, boolean sent) {
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(message);
        switch (accessor.getCommand()) {
            case CONNECT:
                String session_id = accessor.getSessionId();
                String user_id = Objects.requireNonNull(accessor.getFirstNativeHeader("user-id"));
                LoginSessionRequest loginSessionRequest = LoginSessionRequest.builder()
                                .type("login")
                                .session_id(session_id).user_id(user_id).build();
                tcpClientGateway.send(loginSessionRequest.toString());

                List<String> roomList = communityClient.getRoomList(Long.valueOf(user_id));
                StateRequest stateRequest = StateRequest.builder()
                        .type("connect")
                        .userId(user_id)
                        .ids(roomList).build();
                messageSender.signaling(stateTopic,stateRequest);
                break;

            case DISCONNECT:
                String sessionId = accessor.getSessionId();
                LoginSessionRequest logoutSessionRequest = LoginSessionRequest.builder()
                                .type("logout")
                                .session_id(sessionId).build();
                String id = tcpClientGateway.send(logoutSessionRequest.toString());
                String[] items = id.split(",");
                setRoomTime(items[0],items[1]);
                List<String> rList = communityClient.getRoomList(Long.valueOf(items[0]));
                StateRequest request = StateRequest.builder()
                        .type("disconnect")
                        .userId(items[0])
                        .ids(rList).build();
                messageSender.signaling(stateTopic,request);
                break;
            default:
                break;
        }
    }

    public void setRoomTime(String userId, String lastRoom) {
        MessageTime result = messageTimeRepository.findByChannelId(lastRoom);
        if (result == null) {
            Map<String, LocalDateTime> users = new HashMap<>();
            users.put(userId, LocalDateTime.now());
            MessageTime messageTime = MessageTime.builder()
                    .channelId(lastRoom)
                    .read(users).build();
            messageTimeRepository.save(messageTime);
        } else {
            Map<String, LocalDateTime> read = result.getRead();
            read.put(userId,LocalDateTime.now());
            result.setRead(read);
            messageTimeRepository.save(result);
        }
    }
}
