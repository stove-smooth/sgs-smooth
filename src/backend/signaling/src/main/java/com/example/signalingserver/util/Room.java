package com.example.signalingserver.util;

import com.example.signalingserver.dto.request.AudioStateRequest;
import com.example.signalingserver.dto.request.VideoStateRequest;
import com.example.signalingserver.dto.response.ParticipantInfoResponse;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import lombok.extern.slf4j.Slf4j;
import org.kurento.client.Continuation;
import org.kurento.client.MediaPipeline;
import org.kurento.jsonrpc.JsonUtils;
import org.springframework.web.socket.WebSocketSession;

import javax.annotation.PreDestroy;
import java.io.Closeable;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

import static com.example.signalingserver.util.Message.*;

@Slf4j
public class Room implements Closeable {

    private final String roomId;
    private final String communityId;
    private final MediaPipeline pipeline;
    private final ConcurrentMap<String, UserSession> participants = new ConcurrentHashMap<>();

    private static final int ROOM_LIMIT = 25;

    public Room(String roomId, MediaPipeline pipeline, String communityId) {
        this.roomId = roomId;
        this.pipeline = pipeline;
        this.communityId = communityId;
    }

    public String getRoomId() {
        return this.roomId;
    }

    public String getPipeLineId() {
        return this.pipeline.getId();
    }

    @PreDestroy
    private void shutdown() {
        this.close();
    }

    public UserSession join(String userId, WebSocketSession session, String communityId, boolean video, boolean audio) throws IOException {
        final UserSession participant = new UserSession(userId, this.roomId, session, this.pipeline, communityId, video, audio);
        // 최대 접속 인원 초과 시 입장 제한
        if (this.participants.size() > ROOM_LIMIT) {
            final JsonObject limitJoinAnswerMsg = limitJoinAnswer(this.roomId);
            participant.sendMessage(limitJoinAnswerMsg);
            return null;
        }
        joinRoom(participant);
        participants.put(participant.getUserId(), participant);
        sendParticipantNames(participant);
        return participant;
    }

    public void leave(UserSession user) throws IOException {
        this.removeParticipant(user.getUserId());
        user.close();
    }

    private Collection<String> joinRoom(UserSession newParticipant) throws IOException {
        ParticipantInfoResponse participantInfoResponse = new ParticipantInfoResponse(
                newParticipant.getUserId(), newParticipant.getVideo(), newParticipant.getAudio());
        final JsonElement participantInfo = JsonUtils.toJsonObject(participantInfoResponse);
        final JsonObject newParticipantMsg = newParticipantArrived(participantInfo);
        final List<String> participantsList = new ArrayList<>(participants.values().size());

        for (final UserSession participant : participants.values()) {
            try {
                participant.sendMessage(newParticipantMsg);
            } catch (final IOException e) {
                log.debug("ROOM {}: participant {} could not be notified", roomId, participant.getUserId(), e);
            }
            participantsList.add(participant.getUserId());
        }
        return participantsList;
    }

    private void removeParticipant(String userId) throws IOException {
        participants.remove(userId);

        final List<String> unnotifiedParticipants = new ArrayList<>();
        final JsonObject participantLeftJson = participantLeft(userId);
        for (final UserSession participant : participants.values()) {
            try {
                participant.cancelVideoFrom(userId);
                participant.sendMessage(participantLeftJson);
            } catch (final IOException e) {
                unnotifiedParticipants.add(participant.getUserId());
            }
        }

        if (!unnotifiedParticipants.isEmpty()) {
            log.debug("ROOM {}: The users {} could not be notified that {} left the room", this.roomId,
                    unnotifiedParticipants, userId);
        }

    }

    public void sendParticipantNames(UserSession user) throws IOException {

        final JsonArray participantsArray = new JsonArray();
        for (final UserSession participant : this.getParticipants()) {
            if (!participant.equals(user)) {
                ParticipantInfoResponse participantInfoResponse = new ParticipantInfoResponse(
                        participant.getUserId(), participant.getVideo(), participant.getAudio());
                final JsonElement participantInfo = JsonUtils.toJsonObject(participantInfoResponse);
                participantsArray.add(participantInfo);
            }
        }

        final JsonObject existingParticipantsMsg = existingParticipants(participantsArray);
        user.sendMessage(existingParticipantsMsg);
    }

    public void updateVideo(VideoStateRequest request) throws IOException {
        final UserSession user = participants.get(request.getUserId());
        user.setVideo(request.isVideo());
        final JsonObject updateVideoStateJson = videoStateAnswer(request.getUserId(), request.isVideo());
        for (final UserSession participant: participants.values()) {
            participant.sendMessage(updateVideoStateJson);
        }
    }

    public void updateAudio(AudioStateRequest request) throws IOException {
        final UserSession user = participants.get(request.getUserId());
        user.setAudio(request.isAudio());
        final JsonObject updateAudioStateJson = audioStateAnswer(request.getUserId(), request.isAudio());
        for (final UserSession participant: participants.values()) {
            participant.sendMessage(updateAudioStateJson);
        }
    }

    public Collection<UserSession> getParticipants() {
        return participants.values();
    }

    public UserSession getParticipant(String name) {
        return participants.get(name);
    }

    @Override
    public void close() {
        for (final UserSession user : participants.values()) {
            try {
                user.close();
            } catch (IOException e) {
                log.debug("ROOM {}: Could not invoke close on participant {}", this.roomId, user.getUserId(), e);
            }
        }

        participants.clear();
        pipeline.release(new Continuation<Void>() {

            @Override
            public void onSuccess(Void result) throws Exception { }

            @Override
            public void onError(Throwable cause) throws Exception { }
        });
    }
}
