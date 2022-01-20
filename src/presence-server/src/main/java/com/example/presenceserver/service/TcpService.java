package com.example.presenceserver.service;

import com.example.presenceserver.dto.request.LoginSessionRequest;
import com.google.gson.Gson;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;

@Slf4j
@Service
@RequiredArgsConstructor
public class TcpService {

    private final RedisTemplate<String, Object> redisTemplate;

    public String processMessage(String message) {
        LoginSessionRequest request = new Gson().fromJson(message,LoginSessionRequest.class);

        if (request.getType().equals("login")) {
            String session_id = request.getSession_id();
            String temp = "USER" + request.getUser_id();
            long time = 24 * 60 * 60 * 1000L;
            redisTemplate.opsForValue().set(temp,"home" ,time, TimeUnit.MILLISECONDS);
            redisTemplate.opsForValue().set(session_id,request.getUser_id(),time,TimeUnit.MILLISECONDS);
        } else if (request.getType().equals("logout")) {
            String session_id = request.getSession_id();
            String user_Id = redisTemplate.opsForValue().get(session_id).toString();

            redisTemplate.delete(session_id);
            redisTemplate.delete(user_Id);
        }

        return "반환메세지";
    }

    public String processMessage2(String message, String type) {
        log.info(message);
        log.info(type);
        return "dd";
    }
}
