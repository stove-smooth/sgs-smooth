package com.example.presenceserver.service;

import com.example.presenceserver.dto.request.LoginSessionRequest;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

@Slf4j
@Service
@RequiredArgsConstructor
public class TcpService {

    private final RedisTemplate<String, Object> redisTemplate;
    private final ObjectMapper objectMapper;
//    private final HashOperations<String,String, Object> hashOperations;
    private long TIME = 24 * 60 * 60 * 1000L;

    public String processMessage(String message) throws JsonProcessingException {
        LoginSessionRequest request = new Gson().fromJson(message,LoginSessionRequest.class);
        log.info(String.valueOf(request));
        switch (request.getType()) {
            case "login": {
                String user_id = "USER" + request.getUser_id();
                String session_id = request.getSession_id();
                redisTemplate.opsForValue().set(user_id, "home", TIME, TimeUnit.MILLISECONDS);
                redisTemplate.opsForValue().set(session_id, request.getUser_id(), TIME, TimeUnit.MILLISECONDS);
                break;
            }
            case "logout": {
                String session_id = request.getSession_id();
                String user_Id = String.valueOf(redisTemplate.opsForValue().get(session_id));

                String state = String.valueOf(redisTemplate.opsForValue().get("USER" + user_Id));
                if (!state.equals("null")) {
                    String list = String.valueOf(redisTemplate.opsForValue().get("CH" + state));
                    if (!list.equals("null")) {
                        ArrayList arrayList = objectMapper.readValue(list, ArrayList.class);
                        arrayList.remove(user_Id);
                        redisTemplate.opsForValue().set("CH" + state, objectMapper.writeValueAsString(arrayList));
                        redisTemplate.delete(session_id);
                        redisTemplate.delete("USER" + user_Id);
                    } else {
                        redisTemplate.delete(session_id);
                        redisTemplate.delete("USER" + user_Id);
                    }
                } else {
                    redisTemplate.delete(session_id);
                    redisTemplate.delete("USER" + user_Id);
                }
                break;
            }
            case "state": {
                String user_id = "USER" + request.getUser_id();
                String channel_id = request.getChannel_id();
                redisTemplate.opsForValue().set(user_id, channel_id, TIME, TimeUnit.MILLISECONDS);

                String list = String.valueOf(redisTemplate.opsForValue().get("CH" + channel_id));
                if (!list.equals("null")) {
                    ArrayList arrayList = objectMapper.readValue(list, ArrayList.class);
                    arrayList.add(request.getUser_id());
                    redisTemplate.opsForValue().set("CH" + channel_id, objectMapper.writeValueAsString(arrayList));
                } else {
                    List<String> temp = new ArrayList<>();
                    temp.add(request.getUser_id());
                    ObjectMapper mapper = new ObjectMapper();
                    String s = mapper.writeValueAsString(temp);
                    redisTemplate.opsForValue().set("CH" + channel_id, s, TIME, TimeUnit.MILLISECONDS);
                }
                break;
            }
        }

        return "반환메세지";
    }
}
