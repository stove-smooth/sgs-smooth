package com.example.signalingserver.controller;

import com.example.signalingserver.dto.request.JoinRequest;
import com.example.signalingserver.service.RoomService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

@Slf4j
@Controller
@RequiredArgsConstructor
public class MessageController {

    private final SimpMessagingTemplate template;
    private final RoomService roomService;

    private static final String TOPIC_PREFIX = "/sub";
    private static final String CHANNEL = "/channel/";
    private static final String ROOM = "/room/";

    /**
     * 1. join
     * 2. receive
     * 3. leave
     * 4. onIceCandidate
     */

    @MessageMapping("/channel/join")
    public void joinChannel(JoinRequest request) {
        String topic = TOPIC_PREFIX + CHANNEL + request.getId();
        // 기존 입장한 유저들에게 새로 입장한 유저 알리기
        template.convertAndSend(topic, roomService.newParticipantArrived(request));
        // 새로 입장한 유저에게 기존 유저 정보 알리기
        template.convertAndSend(topic, roomService.join(request, true));
    }
}
