package com.example.signalingserver.service;

import com.example.signalingserver.config.tcp.TcpClientGateway;
import com.example.signalingserver.dto.request.*;
import com.example.signalingserver.util.Room;
import com.example.signalingserver.util.UserSession;
import com.example.signalingserver.util.RoomManager;
import com.example.signalingserver.util.UserRegister;
import com.example.signalingserver.util.type.State;
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
import org.springframework.data.redis.core.SetOperations;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import javax.websocket.OnError;
import java.io.IOException;
import java.util.Objects;
import java.util.concurrent.TimeUnit;

import static com.example.signalingserver.util.type.EventType.*;

@Slf4j
@Component
@RequiredArgsConstructor
public class MessageHandler extends TextWebSocketHandler {

    @Value("${property.ip}")
    private String IP;

    // private final JwtFilter jwtFilter;
    private final KurentoClient kurento;
    private final RoomManager roomManager;
    private final UserRegister registry;
    private final TcpClientGateway tcpClientGateway;

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

            if (user != null) {
                log.info("Incoming message from user '{}': {}", user.getUserId(), jsonMessage);
            } else {
                log.info("Incoming message from new user: {}", jsonMessage);
            }

            switch (jsonMessage.get(ID).getAsString()) {
                // ??? ??????
                case JOIN:
                    JoinRequest joinRequest = mapper.readValue(message.getPayload(), JoinRequest.class);
                    join(joinRequest, session);
                    break;
                // SDP ?????? ??????
                case RECEIVE_VIDEO_FROM:
                    ReceiveVideoRequest receiveVideoRequest
                            = mapper.readValue(message.getPayload(), ReceiveVideoRequest.class);
                    final String userId = receiveVideoRequest.getUserId();
                    final UserSession sender = registry.getByUserId(userId);
                    final String sdpOffer = receiveVideoRequest.getSdpOffer();
                    user.receiveVideoFrom(sender, sdpOffer);
                    break;
                // ICE Candidate ?????? ??????
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
                // ????????? ?????? ??????
                case VIDEO_STATE_FROM:
                    VideoStateRequest videoStateRequest
                            = mapper.readValue(message.getPayload(), VideoStateRequest.class);
                    updateVideo(videoStateRequest, user);
                    break;
                // ????????? ?????? ??????
                case AUDIO_STATE_FROM:
                    AudioStateRequest audioStateRequest
                            = mapper.readValue(message.getPayload(), AudioStateRequest.class);
                    updateAudio(audioStateRequest, user);
                    break;
                // ??? ?????????
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
        if (Objects.isNull(user)) return;
        Room room = roomManager.getRoom(user.getRoomId(), user.getCommunityId());
        room.leave(user);

        // redis?????? ?????? ??????
        SetOperations<String, String> setOperations = redisTemplate.opsForSet();
        try {
            log.info("[redis] remove key : {}, value : {}", room.getRoomId(), user.getUserId());
            setOperations.remove(room.getRoomId(), user.getUserId());
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (room.getParticipants().isEmpty()) {
            roomManager.removeRoom(room);
            // redis?????? ??? ??????
            try {
                log.info("[redis] remove key : {}", room.getRoomId());
                redisTemplate.delete(room.getRoomId());
                redisTemplate.delete(room.getRoomId()+PIPELINE);
            } catch (Exception e) {
                e.printStackTrace();
            }

            // kurento media pipeline ??????
            kurento.getServerManager().getPipelines().stream()
                    .filter(pipeline -> pipeline.getId().equals(room.getPipeLineId()))
                    .findAny().ifPresent(pipeline -> pipeline.release());

            try {
                log.info("[redis] remove key : {}, value : {}", SERVER + IP, room.getRoomId());
                setOperations.remove(SERVER + IP, room.getRoomId());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        log.info("[Connection Closed] user {}, CloseStatus : {}", user.getUserId(), status);
        // ???????????? ????????? ?????? ?????? ??????
        try {
            StateRequest logoutRequest = new StateRequest(State.DISCONNECT, user.getUserId(), user.getCommunityId(), user.getRoomId());
            log.info("PRESENCE SERVER SEND : {}", logoutRequest.toString());
            tcpClientGateway.send(logoutRequest.toString());
        } catch (Exception e) {
            log.error("PRESENCE ERROR : {}", e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * key                        value
     * c-{channelId}              ????????? ?????? ???????????? id ?????????
     * r-{roomId}                 ???????????? ?????? ???????????? id ?????????
     * c-{channelId}-pipeline     {channelId}??? ??????????????? ?????????
     * r-{roomId}-pipeline        {roomId}??? ??????????????? ?????????
     */

    private void join(JoinRequest request, WebSocketSession session) throws IOException {
        // ?????? ??????
//        if (!jwtFilter.isJwtValid(request.getToken()))
//            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);

        final String roomId = request.getRoomId();
        final String userId = request.getUserId();
        final String communityId = request.getCommunityId();
        final boolean video = request.isVideo();
        final boolean audio = request.isAudio();

        Room room = roomManager.getRoom(roomId, communityId);
        final UserSession user = room.join(userId, session, communityId, video, audio);
        // ?????? ?????? ?????? ?????? ??? ?????? ??????
        if (Objects.isNull(user)) return;
        registry.register(user);

        try {
            log.info("[redis] save key : {}, value : {}", roomId+PIPELINE, room.getPipeLineId());
            ValueOperations<String, String> valueOperations = redisTemplate.opsForValue();
            valueOperations.set(roomId + PIPELINE, room.getPipeLineId(), TIME, TimeUnit.MILLISECONDS);
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            log.info("[redis] save key : {}, value : {}", roomId, userId);
            log.info("[redis] save key : {}, value : {}", SERVER + IP, roomId);
            SetOperations<String, String> setOperations = redisTemplate.opsForSet();
            setOperations.add(roomId, userId);
            setOperations.add(SERVER + IP, roomId);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void leave(UserSession user) throws IOException {
        final Room room = roomManager.getRoom(user.getRoomId(), user.getCommunityId());
        room.leave(user);
    }

    private void updateVideo(VideoStateRequest request, UserSession user) throws IOException {
        final Room room = roomManager.getRoom(user.getRoomId(), user.getCommunityId());
        room.updateVideo(request);
    }

    private void updateAudio(AudioStateRequest request, UserSession user) throws IOException {
        final Room room = roomManager.getRoom(user.getRoomId(), user.getCommunityId());
        room.updateAudio(request);
    }
}