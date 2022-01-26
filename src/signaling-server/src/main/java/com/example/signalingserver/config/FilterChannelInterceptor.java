package com.example.signalingserver.config;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.stereotype.Component;

import java.util.Objects;

@Slf4j
@RequiredArgsConstructor
@Component
public class FilterChannelInterceptor implements ChannelInterceptor {

    private final JwtTokenFilter jwtTokenFilter;
    private final RedisTemplate redisTemplate;

    private static final String ACCESS_TOKEN = "access-token";
    private static final String USER_ID = "user-id";
    private static final String CHANNEL_ID = "channel-id";

    // TODO JWT 검증
    @Override
    public Message<?> preSend(Message<?> message, MessageChannel channel) {
//        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(message);
//        if (CONNECT.equals(accessor.getCommand())) {
//            if (!jwtTokenFilter.isJwtValid(Objects.requireNonNull(accessor.getFirstNativeHeader(ACCESS_TOKEN)))) {
//                log.info("실패");
//                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
//            }
//        }
        return message;
    }

    @Override
    public void postSend(Message<?> message, MessageChannel channel, boolean sent) {
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(message);
        switch (accessor.getCommand()) {
            case CONNECT:
                String connectSessionId = accessor.getSessionId();
//                String connectUserId = Objects.requireNonNull(accessor.getFirstNativeHeader(USER_ID));
//                String connectChannelId = Objects.requireNonNull(accessor.getFirstNativeHeader(CHANNEL_ID));
                
                // 유저 세션 저장
                // 상태관리서버 업데이트
                
                break;
            case DISCONNECT:
                String disconnectSessionId = accessor.getSessionId();
                
                // 유저 세션 삭제
                // 상태관리서버 업데이트
                
                break;
            default:
//                throw new ResponseStatusException(HttpStatus.BAD_REQUEST);
                break;
        }
    }

}

