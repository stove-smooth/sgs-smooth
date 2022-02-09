package com.example.presenceserver.service;

import com.example.presenceserver.dto.request.LoginSessionRequest;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@Slf4j
@Service
@RequiredArgsConstructor
public class PresenceService {
    private final RedisTemplate<String, Object> redisTemplate;
    private final ObjectMapper objectMapper;
    private long TIME = 24 * 60 * 60 * 1000L;

    public void uploadState(LoginSessionRequest loginSessionRequest) {
        String session_id = loginSessionRequest.getSession_id();
        String temp = "USER" + loginSessionRequest.getUser_id();
        redisTemplate.opsForValue().set(temp,"home" ,TIME, TimeUnit.MILLISECONDS);
        redisTemplate.opsForValue().set(session_id,loginSessionRequest.getUser_id(),TIME,TimeUnit.MILLISECONDS);
    }

    public void deleteState(LoginSessionRequest loginSessionRequest) throws JsonProcessingException {
        String session_id = loginSessionRequest.getSession_id();
        String user_Id = redisTemplate.opsForValue().get(session_id).toString();

        String state = String.valueOf(redisTemplate.opsForValue().get("USER"+user_Id));
        if (!state.equals("null")) {
            String list = String.valueOf(redisTemplate.opsForValue().get("CH" + state));
            if (!list.equals("null")) {
                ArrayList arrayList = objectMapper.readValue(list, ArrayList.class);
                arrayList.remove(user_Id);
                redisTemplate.opsForValue().set("CH"+state,objectMapper.writeValueAsString(arrayList));
                redisTemplate.delete(session_id);
                redisTemplate.delete("USER"+user_Id);
            } else {
                redisTemplate.delete(session_id);
                redisTemplate.delete("USER"+user_Id);
            }
        } else {
            redisTemplate.delete(session_id);
            redisTemplate.delete("USER"+user_Id);
        }
    }

    public void changeState(LoginSessionRequest loginSessionRequest) throws JsonProcessingException {
        String user_id = "USER" + loginSessionRequest.getUser_id();
        String channel_id = loginSessionRequest.getChannel_id();
        redisTemplate.opsForValue().set(user_id,channel_id,TIME,TimeUnit.MILLISECONDS);

        String list = String.valueOf(redisTemplate.opsForValue().get("CH"+channel_id));
        if (!list.equals("null")) {
            ArrayList arrayList = objectMapper.readValue(list, ArrayList.class);
            arrayList.add(loginSessionRequest.getUser_id());
            redisTemplate.opsForValue().set("CH"+channel_id,objectMapper.writeValueAsString(arrayList));
        } else {
            List<String> temp = new ArrayList<>();
            temp.add(loginSessionRequest.getUser_id());
            ObjectMapper mapper = new ObjectMapper();
            String s = mapper.writeValueAsString(temp);
            redisTemplate.opsForValue().set("CH"+channel_id,s,TIME,TimeUnit.MILLISECONDS);
        }
    }

    public Map<Long,Boolean> findRead(List<Long> requestAccountIds) {
        Map<Long,Boolean> check = new HashMap<>();
        List<Long> alarm = new ArrayList<>();
        for (Long i : requestAccountIds) {
            if (redisTemplate.opsForValue().get("USER" + i) == null) {
                check.put(i,false);
                alarm.add(i);
            } else {
                check.put(i,true);
            }
        }
        return check;
    }
//
//    public void statusChange(Long id, String status) {
//        redisTemplate.opsForValue().set("STATUS" + id, status, TIME, TimeUnit.MILLISECONDS);
//    }
}
