package com.example.presenceserver.service;

import com.example.presenceserver.client.ChatClient;
import com.example.presenceserver.config.client.TcpClientGateway;
import com.example.presenceserver.dto.request.LoginSessionRequest;
import com.example.presenceserver.dto.request.SignalingRequest;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
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
public class TcpService {

    private final RedisTemplate<String, Object> redisTemplate;
    private final TcpClientGateway tcpClientGateway;
    private final ObjectMapper objectMapper;
    private long TIME = 24 * 60 * 60 * 1000L;
    private static final String SEP = ",";
    private static final String ONLINE = "online";
    private static final String OFFLINE = "offline";

    private final ChatClient chatClient;

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
                String list = String.valueOf(redisTemplate.opsForValue().get(state));
                if (!list.equals("null")) {
                    if (!list.equals("[]")) {
                        HashSet hashSet = objectMapper.readValue(list, HashSet.class);
                        log.info(String.valueOf(hashSet));
                        hashSet.remove(user_Id);
                        log.info(String.valueOf(hashSet));
                        redisTemplate.opsForValue().set(state, objectMapper.writeValueAsString(hashSet));
                    }
                }
                redisTemplate.delete(session_id);
                redisTemplate.delete("USER" + user_Id);
                redisTemplate.opsForValue().set(status, OFFLINE, TIME, TimeUnit.MILLISECONDS);
                tcpClientGateway.send(user_Id + SEP + OFFLINE);
                String temp = user_Id + "," + state;
                return temp;
            }
            case "state": {
                String user_id = "USER" + request.getUser_id();
                String lastRoom = String.valueOf(redisTemplate.opsForValue().get(user_id));
                String lastRoomList = String.valueOf(redisTemplate.opsForValue().get(lastRoom));
                log.info("지난 방 인원들:" + lastRoomList);
                // 지난 방에서 내 기록 삭제
                if (!lastRoomList.equals("null")) {
                    if (!lastRoomList.equals("[]")) {
                        HashSet hashSet = objectMapper.readValue(lastRoomList, HashSet.class);
                        hashSet.remove(request.getUser_id());
                        redisTemplate.opsForValue().set(lastRoom,objectMapper.writeValueAsString(hashSet));
                    }
                }

                String place = request.getChannel_id();
                redisTemplate.opsForValue().set(user_id, place, TIME, TimeUnit.MILLISECONDS);

                String list = String.valueOf(redisTemplate.opsForValue().get(place));
                log.info(list);
                if (!list.equals("null")) {
                    HashSet hashSet = objectMapper.readValue(list, HashSet.class);
                    hashSet.add(request.getUser_id());
                    redisTemplate.opsForValue().set(place, objectMapper.writeValueAsString(hashSet));
                } else {
                    Set<String> temp = new HashSet<>();
                    temp.add(request.getUser_id());
                    ObjectMapper mapper = new ObjectMapper();
                    String s = mapper.writeValueAsString(temp);
                    redisTemplate.opsForValue().set(place, s, TIME, TimeUnit.MILLISECONDS);
                }
                return lastRoom + SEP + place;
            }
            case "direct":
            case "community": {
                List<Long> check = new ArrayList<>();
                for (Long i : request.getIds()) {
                    if (!String.valueOf(redisTemplate.opsForValue().get("USER" + i)).equals(request.getChannel_id())) {
                        check.add(i);
                    }
                }
                return String.valueOf(check);
            }
            case "before-enter": {
                Map<String,List<String>> result = new HashMap<>();
                String lastRoom = String.valueOf(redisTemplate.opsForValue().get("USER" + request.getUser_id()));
                String lastRoomList = String.valueOf(redisTemplate.opsForValue().get(lastRoom));
                if (!lastRoom.equals("null")) {
                    if (!lastRoom.equals("[]")) {
                        HashSet hashSet = objectMapper.readValue(lastRoomList, HashSet.class);
                        hashSet.remove(request.getUser_id());
                        redisTemplate.opsForValue().set(lastRoom,objectMapper.writeValueAsString(hashSet));
                    }
                }
                List<String> keys = redisTemplate.keys("*").stream()
                        .filter(k -> String.valueOf(k).startsWith("com" + request.getCommunity_id())).collect(Collectors.toList());
                for (String i : keys) {
                    String value = String.valueOf(redisTemplate.opsForValue().get(i));
                    if (value.equals("null") || value.equals("[]")) {
                        ArrayList arrayList = new ArrayList();
                        String channelId = i.split(",")[1].split("-")[1];
                        result.put(channelId,arrayList);
                    } else {
                        ArrayList arrayList = objectMapper.readValue(value, ArrayList.class);
                        String channelId = i.split(",")[1].split("-")[1];
                        result.put(channelId,arrayList);
                    }

                }
                return objectMapper.writeValueAsString(result);
            }
            case "enter": {
                String user_id = "USER" + request.getUser_id();
                String lastRoom = String.valueOf(redisTemplate.opsForValue().get(user_id));
                log.info("enter지난 방:" + lastRoom);
                String lastRoomList = String.valueOf(redisTemplate.opsForValue().get(lastRoom));
                log.info("enter지난 방 인원들:" + lastRoomList);
                // 지난 방에서 내 기록 삭제
                if (!lastRoomList.equals("null")) {
                    if (!lastRoomList.equals("[]")) {
                        HashSet hashSet = objectMapper.readValue(lastRoomList, HashSet.class);
                        hashSet.remove(request.getUser_id());
                        redisTemplate.opsForValue().set(lastRoom,objectMapper.writeValueAsString(hashSet));
                    }
                }

                String place =  "com" + request.getCommunity_id() + SEP + request.getChannel_id();
                redisTemplate.opsForValue().set(user_id, place, TIME, TimeUnit.MILLISECONDS);

                String list = String.valueOf(redisTemplate.opsForValue().get(place));
                if (!list.equals("null")) {
                    HashSet hashSet = objectMapper.readValue(list, HashSet.class);
                    hashSet.add(request.getUser_id());
                    redisTemplate.opsForValue().set(place, objectMapper.writeValueAsString(hashSet));
                } else {
                    Set<String> temp = new HashSet<>();
                    temp.add(request.getUser_id());
                    ObjectMapper mapper = new ObjectMapper();
                    String s = mapper.writeValueAsString(temp);
                    redisTemplate.opsForValue().set(place, s, TIME, TimeUnit.MILLISECONDS);
                }

                Map<String,List<String>> result = new HashMap<>();
                List<String> keys = redisTemplate.keys("*").stream()
                        .filter(k -> String.valueOf(k).startsWith("com" + request.getCommunity_id())).collect(Collectors.toList());
                for (String i : keys) {
                    log.info("enter방이름:" + i);
                    String value = String.valueOf(redisTemplate.opsForValue().get(i));
                    if (value.equals("null") || value.equals("[]")) {
                        ArrayList arrayList = new ArrayList();
                        String channelId = i.split(",")[1].split("-")[1];
                        result.put(channelId,arrayList);
                    } else {
                        ArrayList arrayList = objectMapper.readValue(value, ArrayList.class);
                        String channelId = i.split(",")[1].split("-")[1];
                        result.put(channelId,arrayList);
                    }

                }
                return objectMapper.writeValueAsString(result);
            }
            case "signaling": {
                if (request.getCommunity_id() != null) {
                    String lastRoom = "com" + request.getCommunity_id() + SEP + request.getChannel_id();
                    log.info(lastRoom);
                    String lastRoomList = String.valueOf(redisTemplate.opsForValue().get(lastRoom));
                    if (!lastRoom.equals("null")) {
                        if (!lastRoom.equals("[]")) {
                            HashSet hashSet = objectMapper.readValue(lastRoomList, HashSet.class);
                            hashSet.remove(request.getUser_id());
                            redisTemplate.opsForValue().set(lastRoom,objectMapper.writeValueAsString(hashSet));
                        }
                    }
                    String value = String.valueOf(redisTemplate.opsForValue().get(lastRoom));
                    log.info("signaling유저리스트커뮤있을때:" + value);
                    ArrayList arrayList = objectMapper.readValue(value, ArrayList.class);
                    SignalingRequest signalingRequest = SignalingRequest.builder()
                            .type("out")
                            .communityId(request.getCommunity_id())
                            .channelId(request.getChannel_id())
                            .ids(arrayList).build();
                    log.info(signalingRequest.toString());
                    chatClient.getSignalingListForCommunity(signalingRequest);
                } else {

                    HashSet hashSet = new HashSet();
                    String lastRoom = request.getChannel_id();
                    String lastRoomList = String.valueOf(redisTemplate.opsForValue().get(lastRoom));
                    if (!lastRoom.equals("null")) {
                        if (!lastRoom.equals("[]")) {
                            hashSet = objectMapper.readValue(lastRoomList, HashSet.class);
                            hashSet.remove(request.getUser_id());
                            redisTemplate.opsForValue().set(lastRoom,objectMapper.writeValueAsString(hashSet));
                        }
                    }
                    String value = String.valueOf(hashSet);
                    log.info("signaling유저리스트커무없을때:" + value);
                    ArrayList arrayList = objectMapper.readValue(value, ArrayList.class);
                    SignalingRequest signalingRequest = SignalingRequest.builder()
                            .type("out")
                            .channelId(lastRoom.split("-")[1])
                            .ids(arrayList).build();
                    chatClient.getSignalingListForDirect(signalingRequest);
                }
                break;
            }
        }

        return "반환메세지";
    }
}
