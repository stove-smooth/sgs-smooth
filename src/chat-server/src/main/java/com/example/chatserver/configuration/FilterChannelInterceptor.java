package com.example.chatserver.configuration;

import io.jsonwebtoken.Jwts;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpStatus;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Slf4j
@Order(Ordered.HIGHEST_PRECEDENCE + 99)
public class FilterChannelInterceptor implements ChannelInterceptor {

    @Value("${jwt.secret_key}")
    private String secretKey;

    @Override
    public Message<?> preSend(Message<?> message, MessageChannel channel) {
        StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(message);
        String token = headerAccessor.getNativeHeader("access-token").get(0);
        log.info(token);
        if (!isJwtValid(token)) {
            log.info("실패");
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
        }
        return message;

    }

    private boolean isJwtValid(String jwt) {
        boolean returnValue = true;
        String subject = null;
        try {
            subject = Jwts.parser().setSigningKey(secretKey)
                    .parseClaimsJws(jwt).getBody()
                    .getSubject();
        } catch (Exception ex) {
            returnValue = false;
        }

        if (subject == null || subject.isEmpty()) {
            returnValue = false;
        }

        return returnValue;
    }
}
