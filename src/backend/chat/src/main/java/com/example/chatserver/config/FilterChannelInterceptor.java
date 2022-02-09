package com.example.chatserver.config;

import com.example.chatserver.client.PresenceClient;
import com.example.chatserver.client.UserClient;
import com.example.chatserver.config.message.JwtTokenFilter;
import com.example.chatserver.dto.request.LoginSessionRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;

import java.util.Objects;


@Slf4j
@RequiredArgsConstructor
@Component
public class FilterChannelInterceptor implements ChannelInterceptor {

    private final JwtTokenFilter jwtTokenFilter;
    private final PresenceClient presenceClient;
    private final TcpClientGateway tcpClientGateway;
    private final UserClient userClient;

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
                tcpClientGateway.send(loginSessionRequest.toString());
//                presenceClient.uploadState(loginSessionRequest);
                break;
                // todo disconnect 여러가지 테스트 (전원끄기, 랜선뽑기 등)
            case DISCONNECT:
                String sessionId = accessor.getSessionId();
                LoginSessionRequest logoutSessionRequest = LoginSessionRequest.builder()
                                .type("logout")
                                .session_id(sessionId).build();
                String id = tcpClientGateway.send(logoutSessionRequest.toString());
                log.info("아이디" + id);
                userClient.changeLastAccess(Long.valueOf(id));
//                presenceClient.deleteState(logoutSessionRequest);
                break;
            default:
                break;
        }
    }
}
