package com.example.signalingserver.util;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketSession;

import java.util.Objects;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class UserRegister {

    private final ConcurrentHashMap<String, UserSession> usersByUserId = new ConcurrentHashMap<>();
    private final ConcurrentHashMap<String, UserSession> usersBySessionId = new ConcurrentHashMap<>();

    public void register(UserSession user) {
        usersByUserId.put(user.getUserId(), user);
        usersBySessionId.put(user.getSession().getId(), user);
    }

    public UserSession getByUserId(String userId) {
        return usersByUserId.get(userId);
    }

    public UserSession getBySession(WebSocketSession session) {
        return usersBySessionId.get(session.getId());
    }

    public boolean exists(String userId) {
        return usersByUserId.keySet().contains(userId);
    }

    public UserSession removeBySession(WebSocketSession session) {
        final UserSession user = getBySession(session);
        // 웹소켓 연결만 하고 방에 입장하지 않고 종료하지 않는 경우 발생하는 예외 처리
        if (!Objects.isNull(user)) {
            usersByUserId.remove(user.getUserId());
            usersBySessionId.remove(session.getId());
            return user;
        }
        return null;
    }
}