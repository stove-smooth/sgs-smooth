package com.example.presenceserver.service;

import com.example.presenceserver.configuration.client.TcpClientGateway;
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
    private final TcpClientGateway tcpClientGateway;
    private final ObjectMapper objectMapper;
    private long TIME = 24 * 60 * 60 * 1000L;
    private static final String SEP = ",";
    private static final String ONLINE = "online";
    private static final String OFFLINE = "offline";

    public String processMessage(String message) throws JsonProcessingException {
        LoginSessionRequest request = new Gson().fromJson(message,LoginSessionRequest.class);
        log.info(String.valueOf(request));
        switch (request.getType()) {
            case "login": {
                String user_id = "USER" + request.getUser_id();
                String status = "STATUS" + request.getUser_id();
                String session_id = request.getSession_id();
                redisTemplate.opsForValue().set(user_id, "home", TIME, TimeUnit.MILLISECONDS);
                redisTemplate.opsForValue().set(status, ONLINE, TIME, TimeUnit.MILLISECONDS);
                redisTemplate.opsForValue().set(session_id, request.getUser_id(), TIME, TimeUnit.MILLISECONDS);
                tcpClientGateway.send(request.getUser_id() + SEP + ONLINE);
                break;
            }
            case "logout": {
                String session_id = request.getSession_id();
                String user_Id = String.valueOf(redisTemplate.opsForValue().get(session_id));
                String status = "STATUS" + user_Id;

                String state = String.valueOf(redisTemplate.opsForValue().get("USER" + user_Id));
                if (!state.equals("null")) {
                    String list = String.valueOf(redisTemplate.opsForValue().get(state));
                    if (!list.equals("null")) {
                        ArrayList arrayList = objectMapper.readValue(list, ArrayList.class);
                        arrayList.remove(user_Id);
                        redisTemplate.opsForValue().set(state, objectMapper.writeValueAsString(arrayList));
                        redisTemplate.opsForValue().set(status, OFFLINE, TIME, TimeUnit.MILLISECONDS);
                        redisTemplate.delete(session_id);
                        redisTemplate.delete("USER" + user_Id);
                    } else {
                        redisTemplate.opsForValue().set(status, OFFLINE, TIME, TimeUnit.MILLISECONDS);
                        redisTemplate.delete(session_id);
                        redisTemplate.delete("USER" + user_Id);
                    }
                } else {
                    redisTemplate.opsForValue().set(status, OFFLINE, TIME, TimeUnit.MILLISECONDS);
                    redisTemplate.delete(session_id);
                    redisTemplate.delete("USER" + user_Id);

                }
                tcpClientGateway.send(request.getUser_id() + SEP + OFFLINE);
                String temp = user_Id + "," + state;
                return temp;
            }
            case "state": {
                String user_id = "USER" + request.getUser_id();
                String lastRoom = redisTemplate.opsForValue().get(user_id).toString();
                log.info(lastRoom);
                String channel_id = request.getChannel_id();
                redisTemplate.opsForValue().set(user_id, channel_id, TIME, TimeUnit.MILLISECONDS);

                String list = String.valueOf(redisTemplate.opsForValue().get(channel_id));
                if (!list.equals("null")) {
                    ArrayList arrayList = objectMapper.readValue(list, ArrayList.class);
                    arrayList.add(request.getUser_id());
                    redisTemplate.opsForValue().set(channel_id, objectMapper.writeValueAsString(arrayList));
                } else {
                    List<String> temp = new ArrayList<>();
                    temp.add(request.getUser_id());
                    ObjectMapper mapper = new ObjectMapper();
                    String s = mapper.writeValueAsString(temp);
                    redisTemplate.opsForValue().set(channel_id, s, TIME, TimeUnit.MILLISECONDS);
                }
                return lastRoom;
            }
        }

        return "반환메세지";
    }
}
