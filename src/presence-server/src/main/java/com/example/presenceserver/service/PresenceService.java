package com.example.presenceserver.service;

import com.example.presenceserver.dto.request.LoginSessionRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;

@Service
@RequiredArgsConstructor
public class PresenceService {
    private final RedisTemplate<String, Object> redisTemplate;

    public void uploadState(LoginSessionRequest loginSessionRequest) {
        String session_id = loginSessionRequest.getSession_id();
        String temp = "USER" + loginSessionRequest.getUser_id();
        long time = 24 * 60 * 60 * 1000L;
        redisTemplate.opsForValue().set(temp,"home" ,time, TimeUnit.MILLISECONDS);
        redisTemplate.opsForValue().set(session_id,loginSessionRequest.getUser_id(),time,TimeUnit.MILLISECONDS);
    }

    public void deleteState(LoginSessionRequest loginSessionRequest) {
        String session_id = loginSessionRequest.getSession_id();
        String user_Id = redisTemplate.opsForValue().get(session_id).toString();

        redisTemplate.delete(session_id);
        redisTemplate.delete(user_Id);
    }
}
