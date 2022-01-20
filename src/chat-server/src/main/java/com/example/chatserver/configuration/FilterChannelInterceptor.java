package com.example.chatserver.configuration;

import com.example.chatserver.client.PresenceClient;
import com.example.chatserver.configuration.message.JwtTokenFilter;
import com.example.chatserver.dto.request.LoginSessionRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.rsocket.RSocketRequester;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;
import reactor.core.publisher.Mono;

import java.util.Objects;


@Slf4j
@RequiredArgsConstructor
@Component
public class FilterChannelInterceptor implements ChannelInterceptor {

    private final JwtTokenFilter jwtTokenFilter;
    private final RedisTemplate<String, Object> redisTemplate;
    private final PresenceClient presenceClient;
    private final TcpClientGateway tcpClientGateway;

    @Override
    public Message<?> preSend(Message<?> message, MessageChannel channel) {
        StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(message);
        if (StompCommand.CONNECT.equals(headerAccessor.getCommand())) {
            if (!jwtTokenFilter.isJwtValid(Objects.requireNonNull(headerAccessor.getFirstNativeHeader("access-token")))) {
                log.info("실패");
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
//                tcpClientGateway.send(loginSessionRequest.toString());
//                presenceClient.uploadState(loginSessionRequest);
                break;
            case DISCONNECT:
                String sessionId = accessor.getSessionId();
                LoginSessionRequest logoutSessionRequest = LoginSessionRequest.builder()
                                .type("logout")
                                .session_id(sessionId).build();
//                tcpClientGateway.send(logoutSessionRequest.toString());
//                presenceClient.deleteState(logoutSessionRequest);
                break;
            default:
                break;
        }
    }
}
