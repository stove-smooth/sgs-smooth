package com.example.notificationserver.service;

import com.example.notificationserver.client.UserClient;
import com.example.notificationserver.dto.request.ChannelMessageRequest;
import com.example.notificationserver.dto.request.DirectMessageRequest;
import com.example.notificationserver.util.FcmUtil;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.MulticastMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Service
@RequiredArgsConstructor
public class NotificationService {

    private final FcmUtil fcm;
    private final UserClient userClient;

    private final static int PROCESS_INTERVAL = 1000 * 2;

    private static ConcurrentHashMap<Long, List<MulticastMessage>> job = new ConcurrentHashMap<>();

    public void sendDirectMessage(DirectMessageRequest request) {

        List<String> targetTokens = getTargetTokens(request.getTarget());
        try {
            MulticastMessage msg = fcm.makeMessage(
                    targetTokens,
                    fcm.makeTitle(request.getUsername(), request.getRoomName()),
                    fcm.makeBody(request.getType(), request.getContent()),
                    fcm.makeImage(request.getType(), request.getContent()),
                    null
            );
            fcm.sendMessage(msg);
        } catch (FirebaseMessagingException e) {
            log.error("FIREBASE ERROR : {}", e);
        }
    }

    // Todo 채널 메세지 배치 처리
    public void sendChannelMessage(ChannelMessageRequest request) {

        List<String> targetTokens = getTargetTokens(request.getTarget());
        try {
            MulticastMessage msg = fcm.makeMessage(
                    targetTokens,
                    fcm.makeTitle(request.getUsername(), request.getChannelName()),
                    fcm.makeBody(request.getType(), request.getContent()),
                    fcm.makeImage(request.getType(), request.getContent()),
                    null
            );
            fcm.sendMessage(msg);
        } catch (FirebaseMessagingException e) {
            log.error("FIREBASE ERROR : {}", e);
        }
    }

    private List<String> getTargetTokens(List<Long> ids) {
        Map<Long, String> deviceTokens = userClient.getUserDeviceToken(ids);
        List<String> targetTokens = new ArrayList<>();
        for (Long key: deviceTokens.keySet()) {
            targetTokens.add(deviceTokens.get(key));
        }
        return targetTokens;
    }
}
