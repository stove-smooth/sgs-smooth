package com.example.notificationserver.service;

import com.example.notificationserver.domain.Device;
import com.example.notificationserver.domain.Notification;
import com.example.notificationserver.dto.request.ChannelMessageRequest;
import com.example.notificationserver.dto.request.DirectMessageRequest;
import com.example.notificationserver.dto.response.DeviceTokenResponse;
import com.example.notificationserver.exception.CustomException;
import com.example.notificationserver.repository.DeviceRepository;
import com.example.notificationserver.util.FcmUtil;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.MulticastMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;

import static com.example.notificationserver.exception.CustomExceptionStatus.REDIS_DEVICE_TOKEN_PARSE_ERROR;

@Slf4j
@Service
@RequiredArgsConstructor
public class NotificationService {

    private final FcmUtil fcm;
    private final DeviceRepository deviceRepository;
    private final RedisTemplate redisTemplate;
    private final MongoTemplate mongoTemplate;
    private final ObjectMapper objectMapper;

    private final String REDIS_DEVICE_KEY_PREFIX = "USERID:";

    private static ConcurrentHashMap<Long, List<MulticastMessage>> job = new ConcurrentHashMap<>();

    public void send(DirectMessageRequest request) {
        Map<Long, DeviceTokenResponse> deviceTokens = getDeviceTokens(request.getTarget());
        Map<String, List<String>> targetTokensByPlatform = getTokensByPlatform(deviceTokens);
        for (Entry<String, List<String>> platform: targetTokensByPlatform.entrySet()) {
            sendMessage(platform.getValue(), request, platform.getKey());
        }
        saveLog(request, targetTokensByPlatform);
    }

    public void send(ChannelMessageRequest request) {
        Map<Long, DeviceTokenResponse> deviceTokens = getDeviceTokens(request.getTarget());
        Map<String, List<String>> targetTokensByPlatform = getTokensByPlatform(deviceTokens);
        for (Entry<String, List<String>> platform: targetTokensByPlatform.entrySet()) {
            sendMessage(platform.getValue(), request, platform.getKey());
        }
        saveLog(request, targetTokensByPlatform);
    }

    // 토큰 조회 시 캐시 먼저 조회하고 없는 정보만 DB에서 조회하기
    private Map<Long, DeviceTokenResponse> getDeviceTokens(String target) {
        Map<Long, DeviceTokenResponse> deviceTokens = new HashMap<>();

        List<Long> originIds = convertStringToList(target);
        List<Long> filterIds = new ArrayList<>();

        ValueOperations<String, String> valueOperations = redisTemplate.opsForValue();
        originIds.forEach(id -> {
            String key = REDIS_DEVICE_KEY_PREFIX + id.toString();
            String value = valueOperations.get(key);
            if (Objects.isNull(value)) {
                filterIds.add(id);
            } else {
                try {
                    deviceTokens.put(id, objectMapper.readValue(value, DeviceTokenResponse.class));
                } catch (JsonProcessingException e) {
                    throw new CustomException(REDIS_DEVICE_TOKEN_PARSE_ERROR);
                }
            }
        });

        List<Device> devices = deviceRepository.findByUserIdList(filterIds);
        devices.forEach(device -> {
            String setKey = REDIS_DEVICE_KEY_PREFIX + device.getUserId().toString();
            DeviceTokenResponse response = DeviceTokenResponse.fromEntity(device);
            valueOperations.set(setKey, response.toString());
            deviceTokens.put(device.getId(), response);
        });
        return deviceTokens;

    }

    // 플랫폼 별로 디바이스 토큰 나누기
    private Map<String, List<String>> getTokensByPlatform(Map<Long, DeviceTokenResponse> deviceTokens) {
        Map<String, List<String>> targetTokensByPlatform = new HashMap<>();
        for (Entry<Long, DeviceTokenResponse> entry: deviceTokens.entrySet()) {
            List<String> tokens = targetTokensByPlatform.get(entry.getValue().getPlatform());
            if (Objects.isNull(tokens))
                tokens = new ArrayList<>();
            tokens.add(entry.getValue().getToken());
            targetTokensByPlatform.put(entry.getValue().getPlatform().toString(), tokens);
        }
        return targetTokensByPlatform;
    }

    // Stirng "[1, 2, 3]" -> List [1, 2, 3]
    private List<Long> convertStringToList(String target) {
        if (target.length() <= 2)
            return new ArrayList<Long>();
        else {
            target = target.substring(1, target.length()-1);
            String[] split = target.split(", ");

            List<Long> ids = new ArrayList<>();
            for (String s: split) {
                ids.add(Long.parseLong(s));
            }
            return ids;
        }
    }

    private void sendMessage(List<String> targetTokens, DirectMessageRequest request, String platform) {
        try {
            MulticastMessage msg = fcm.makeMessage(
                    targetTokens,
                    fcm.makeTitle(request.getUsername(), request.getRoomName()),
                    fcm.makeBody(request.getType(), request.getContent()),
                    fcm.makeImage(request.getType(), request.getContent()),
                    platform,
                    fcm.makeCustomData(null, request.getRoomId())
            );
            fcm.sendMessage(msg);
        } catch (FirebaseMessagingException e) {
            log.error("FIREBASE ERROR : {}", e);
        }
    }

    private void sendMessage(List<String> targetTokens, ChannelMessageRequest request, String platform) {
        try {
            MulticastMessage msg = fcm.makeMessage(
                    targetTokens,
                    fcm.makeTitle(request.getUsername(), request.getChannelName()),
                    fcm.makeBody(request.getType(), request.getContent()),
                    fcm.makeImage(request.getType(), request.getContent()),
                    platform,
                    fcm.makeCustomData(request.getCommunityId(), request.getChannelId())
            );
            fcm.sendMessage(msg);
        } catch (FirebaseMessagingException e) {
            log.error("FIREBASE ERROR : {}", e);
        }
    }

    private void saveLog(DirectMessageRequest request, Map<String, List<String>> target) {
        Notification notification = new Notification(
                request.getUserId().toString(),
                request.getUsername(),
                request.getType(),
                request.getContent(),
                request.getRoomId().toString(),
                request.getRoomName(),
                request.getTarget()
        );
        mongoTemplate.insert(notification);
    }

    private void saveLog(ChannelMessageRequest request, Map<String, List<String>> target) {
        Notification notification = new Notification(
                request.getUserId().toString(),
                request.getUsername(),
                request.getType(),
                request.getContent(),
                request.getChannelId().toString(),
                request.getChannelName(),
                request.getTarget()
        );
        mongoTemplate.insert(notification);
    }
}
