package com.example.signalingserver.config;

import com.example.signalingserver.util.Room;
import com.example.signalingserver.util.UserSession;
import com.example.signalingserver.dto.request.CandidateRequest;
import com.example.signalingserver.dto.request.JoinRequest;
import com.example.signalingserver.dto.request.ReceiveVideoRequest;
import com.example.signalingserver.util.RoomManager;
import com.example.signalingserver.util.UserRegister;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.kurento.client.IceCandidate;
import org.kurento.client.KurentoClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;

import static com.example.signalingserver.util.type.Property.*;

@Slf4j
@Component
@RequiredArgsConstructor
public class MessageHandler extends TextWebSocketHandler {

    @Value("${property.ip}")
    private String IP;

    private final KurentoClient kurento;
    private final RoomManager roomManager;
    private final UserRegister registry;
    // private final JwtFilter jwtFilter;

    private final ObjectMapper mapper;
    private static final Gson gson = new GsonBuilder().create();
    private final RedisTemplate redisTemplate;

    public static final String ID = "id";
    public static final String PIPELINE = "-pipeline";
    private static final String SERVER = "server-";
    private static final long TIME = 24 * 60 * 60 * 1000L;

    @Override
    public void handleTextMessage(WebSocketSession session, TextMessage message) {
        try {
            final JsonObject jsonMessage = gson.fromJson(message.getPayload(), JsonObject.class);
            final UserSession user = registry.getBySession(session);

            switch (jsonMessage.get(ID).getAsString()) {
                case JOIN:
                    JoinRequest joinRequest = mapper.readValue(message.getPayload(), JoinRequest.class);
                    join(joinRequest, session);
                    break;
                case RECEIVE_VIDEO_FROM:
                    ReceiveVideoRequest receiveVideoRequest
                            = mapper.readValue(message.getPayload(), ReceiveVideoRequest.class);
                    final String userId = receiveVideoRequest.getUserId();
                    final UserSession sender = registry.getByUserId(userId);
                    final String sdpOffer = receiveVideoRequest.getSdpOffer();
                    user.receiveVideoFrom(sender, sdpOffer);
                    break;
                case ON_ICE_CANDIDATE:
                    CandidateRequest candidateRequest
                            = mapper.readValue(message.getPayload(), CandidateRequest.class);
                    CandidateRequest.Candidate candidate = candidateRequest.getCandidate();

                    if (user != null) {
                        IceCandidate cand = new IceCandidate(
                                candidate.getCandidate(),
                                candidate.getSdpMid(),
                                candidate.getSdpMLineIndex());
                        user.addCandidate(cand, candidateRequest.getUserId());
                    }
                    break;
                case LEAVE:
                    leave(user);
                    break;
                default:
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        UserSession user = registry.removeBySession(session);
        roomManager.getRoom(user.getRoomId()).leave(user);
        leave(user);
    }

    /**
     * key                        value
     * c-{channelId}              채널에 속한 유저들의 id 리스트
     * r-{roomId}                 채팅방에 속한 유저들의 id 리스트
     * c-{channelId}-pipeline     {channelId}의 파이프라인 아이디
     * r-{roomId}-pipeline        {roomId}의 파이프라인 아이디
     */

    private void join(JoinRequest request, WebSocketSession session) throws IOException {
        // TODO 토큰 확인
//        if (!jwtFilter.isJwtValid(request.getToken()))
//            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);

        final String roomId = request.getRoomId();
        final String userId = request.getUserId();

        Room room = roomManager.getRoom(roomId);
//        try {
//            ValueOperations<String, String> valueOperations = redisTemplate.opsForValue();
//            valueOperations.set(roomId + PIPELINE, room.getPipeLineId(), TIME, TimeUnit.MILLISECONDS);
//        } catch (Exception e) {
//            e.printStackTrace();
//        }

        final UserSession user = room.join(userId, session);
        registry.register(user);
//        try {
//            SetOperations<String, String> setOperations = redisTemplate.opsForSet();
//            setOperations.add(roomId, userId);
//            setOperations.add(SERVER + IP, roomId);
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
    }

    private void leave(UserSession user) throws IOException {
        final Room room = roomManager.getRoom(user.getRoomId());
        room.leave(user);
        // redis에서 유저 삭제
//        SetOperations<String, String> setOperations = redisTemplate.opsForSet();
//        try {
//            setOperations.remove(room.getRoomId(), user.getUserId());
//        } catch (Exception e) {
//            e.printStackTrace();
//        }

        if (room.getParticipants().isEmpty()) {
            roomManager.removeRoom(room);
            // redis에서 방 삭제
//            try {
//                setOperations.remove(room.getRoomId());
//            } catch (Exception e) {
//                e.printStackTrace();
//            }

            // kurento media pipeline 삭제
            kurento.getServerManager().getPipelines().stream()
                    .filter(pipeline -> pipeline.getId().equals(room.getPipeLineId()))
                    .findAny().ifPresent(pipeline -> pipeline.release());
        }

//        try {
//            setOperations.remove(SERVER + IP, room.getRoomId());
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
    }
}