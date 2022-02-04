package com.example.signalingserver.util;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import lombok.extern.slf4j.Slf4j;
import org.kurento.client.Continuation;
import org.kurento.client.MediaPipeline;
import org.springframework.web.socket.WebSocketSession;

import javax.annotation.PreDestroy;
import java.io.Closeable;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

import static com.example.signalingserver.util.type.Message.*;

@Slf4j
public class Room implements Closeable {

    private final String roomId;
    private final MediaPipeline pipeline;
    private final ConcurrentMap<String, UserSession> participants = new ConcurrentHashMap<>();

    public Room(String roomId, MediaPipeline pipeline) {
        this.roomId = roomId;
        this.pipeline = pipeline;
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

    public UserSession join(String userId, WebSocketSession session) throws IOException {
        final UserSession participant = new UserSession(userId, this.roomId, session, this.pipeline);
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
        final JsonObject newParticipantMsg = newParticipantArrived(newParticipant.getUserId());
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
                final JsonElement participantName = new JsonPrimitive(participant.getUserId());
                participantsArray.add(participantName);
            }
        }

        final JsonObject existingParticipantsMsg = existingParticipants(participantsArray);
        user.sendMessage(existingParticipantsMsg);
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
