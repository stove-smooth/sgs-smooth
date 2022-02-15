package com.example.signalingserver.util;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;

import static com.example.signalingserver.service.MessageHandler.ID;
import static com.example.signalingserver.util.type.EventType.*;

public class Message {

    // 새로운 참가자에 대한 정보 전송
    public static JsonObject newParticipantArrived(String userId) {
        final JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty(ID, NEW_PARTICIPANT_ARRIVED);
        jsonObject.addProperty(USER_ID, userId);
        return jsonObject;
    }

    // 참가자 접속 종료에 대한 정보 전송
    public static JsonObject participantLeft(String userId) {
        final JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty(ID, PARTICIPANT_LEFT);
        jsonObject.addProperty(USER_ID, userId);
        return jsonObject;
    }

    // 방에 입장해있는 사용자들에 대한 정보 전송
    public static JsonObject existingParticipants(JsonArray participantsArray) {
        final JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty(ID, EXISTING_PARTICIPANTS);
        jsonObject.add(MEMBERS, participantsArray);
        return jsonObject;
    }

    // 방에 입장해있는 사용자들, ICE candidate 정보 전송
    public static JsonObject iceCandidate(String userId, JsonElement candidate) {
        JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty(ID, ICE_CANDIDATE);
        jsonObject.addProperty(USER_ID, userId);
        jsonObject.add(CANDIDATE, candidate);
        return jsonObject;
    }

    // SDP 정보에 대한 응답
    public static JsonObject receiveVideoAnswer(String userId, String ipSdpAnswer) {
        final JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty(ID, RECEIVE_VIDEO_ANSWER);
        jsonObject.addProperty(USER_ID, userId);
        jsonObject.addProperty(SDP_ANSWER, ipSdpAnswer);
        return jsonObject;
    }

    // 비디오 상태 변경에 대한 응답
    public static JsonObject videoStateAnswer(String userId, String video) {
        final JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty(ID, VIDEO_STATE_ANSWER);
        jsonObject.addProperty(USER_ID, userId);
        jsonObject.addProperty(VIDEO, video);
        return jsonObject;
    }

    // 오디오 상태 변경에 대한 응답
    public static JsonObject audioStateAnswer(String userId, String audio) {
        final JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty(ID, AUDIO_STATE_ANSWER);
        jsonObject.addProperty(USER_ID, userId);
        jsonObject.addProperty(AUDIO, audio);
        return jsonObject;
    }

    // 방 최대 접속 인원 초과 시 참가 제한 응답
    public static JsonObject limitJoinAnswer(String roomId) {
        final JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty(ID, LIMIT_JOIN_ANSWER);
        jsonObject.addProperty(ROOM_ID, roomId);
        return jsonObject;
    }
}
