package com.example.notificationserver.service;

import com.example.notificationserver.domain.Device;
import com.example.notificationserver.dto.request.ChannelMessageRequest;
import com.example.notificationserver.dto.request.DirectMessageRequest;
import com.example.notificationserver.dto.response.DeviceTokenResponse;
import com.example.notificationserver.repository.DeviceRepository;
import com.example.notificationserver.util.FcmUtil;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.MulticastMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Service
@RequiredArgsConstructor
public class NotificationService {

    private final FcmUtil fcm;
    private final DeviceRepository deviceRepository;

    private final static int PROCESS_INTERVAL = 1000 * 2;

    private static ConcurrentHashMap<Long, List<MulticastMessage>> job = new ConcurrentHashMap<>();

    public void send(DirectMessageRequest request) {
        List<Long> ids = convertStringToList(request.getTarget());

        List<Device> devices = deviceRepository.findByUserIdList(ids);
        Map<Long, DeviceTokenResponse> deviceTokens = new HashMap<>();
        devices.forEach(device -> deviceTokens.put(device.getId(), DeviceTokenResponse.fromEntity(device)));

        Map<String, List<String>> targetTokensByPlatform = getTokensByPlatform(deviceTokens);
        for (Entry<String, List<String>> platform: targetTokensByPlatform.entrySet()) {
            sendMessage(platform.getValue(), request, platform.getKey());
        }
    }

    public void send(ChannelMessageRequest request) {
        List<Long> ids = convertStringToList(request.getTarget());

        List<Device> devices = deviceRepository.findByUserIdList(ids);
        Map<Long, DeviceTokenResponse> deviceTokens = new HashMap<>();
        devices.forEach(device -> deviceTokens.put(device.getId(), DeviceTokenResponse.fromEntity(device)));

        Map<String, List<String>> targetTokensByPlatform = getTokensByPlatform(deviceTokens);
        for (Entry<String, List<String>> platform: targetTokensByPlatform.entrySet()) {
            sendMessage(platform.getValue(), request, platform.getKey());
        }
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
}
