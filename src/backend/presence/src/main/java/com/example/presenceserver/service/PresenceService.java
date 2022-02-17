package com.example.presenceserver.service;

import com.example.presenceserver.dto.request.LoginSessionRequest;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class PresenceService {
    private final RedisTemplate<String, Object> redisTemplate;
    private final ObjectMapper objectMapper;
    private long TIME = 24 * 60 * 60 * 1000L;

    public Map<Long,String> getUsersState() {
        Map<Long,String> result = new HashMap<>();
        List<String> keys = redisTemplate.keys("*").stream()
                .filter(k -> String.valueOf(k).contains("STATUS")).collect(Collectors.toList());

        for (String i : keys) {
            String value = redisTemplate.opsForValue().get(i).toString();
            if (value.equals("online")) {
                String user_id = i.split("STATUS")[1];
                result.put(Long.valueOf(user_id),value);
            }
        }

        return result;
    }

    public Map<String,String> getFriendsState(List<String> friendsId) {
        Map<String,String> result = new HashMap<>();

        for (String i : friendsId) {
            String state = String.valueOf(redisTemplate.opsForValue().get("USER" + i));
            if (state.equals("null")) {
                result.put(i,"offline");
            } else {
                result.put(i,state);
            }
        }
        return result;
    }

    public Map<String,String> getState() {
        Map<String,String> result = new HashMap<>();
        List<String> keys = redisTemplate.keys("*").stream()
                .filter(k -> String.valueOf(k).contains("STATUS")).collect(Collectors.toList());
        for (String i : keys) {
            String value = redisTemplate.opsForValue().get(i).toString();
            result.put(i,value);
        }
        return result;
    }

    public Map<String, String> allInfo() {
        Map<String,String> result = new HashMap<>();
        List<String> keys = redisTemplate.keys("*").stream().collect(Collectors.toList());

        for (String i : keys) {
            String value = redisTemplate.opsForValue().get(i).toString();
            result.put(i,value);
        }
        return result;
    }

    public void deleteAll() {
        List<String> keys = redisTemplate.keys("*").stream().collect(Collectors.toList());
        for (String i : keys) {
            redisTemplate.opsForValue().getAndDelete(i);
        }
    }
}
