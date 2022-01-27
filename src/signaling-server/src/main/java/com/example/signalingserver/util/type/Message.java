package com.example.signalingserver.util.type;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;

import static com.example.signalingserver.config.MessageHandler.ID;
import static com.example.signalingserver.util.type.Property.*;

public class Message {

    public static JsonObject newParticipantArrived(String userId) {
        final JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty(ID, NEW_PARTICIPANT_ARRIVED);
        jsonObject.addProperty(USER_ID, userId);
        return jsonObject;
    }

    public static JsonObject participantLeft(String userId) {
        final JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty(ID, PARTICIPANT_LEFT);
        jsonObject.addProperty(USER_ID, userId);
        return jsonObject;
    }

    public static JsonObject existingParticipants(JsonArray participantsArray) {
        final JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty(ID, EXISTING_PARTICIPANTS);
        jsonObject.add(MEMBERS, participantsArray);
        return jsonObject;
    }

    public static JsonObject iceCandidate(String userId, JsonElement candidate) {
        JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty(ID, ICE_CANDIDATE);
        jsonObject.addProperty(USER_ID, userId);
        jsonObject.add(CANDIDATE, candidate);
        return jsonObject;
    }

    public static JsonObject receiveVideoAnswer(String userId, String ipSdpAnswer) {
        final JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty(ID, RECEIVE_VIDEO_ANSWER);
        jsonObject.addProperty(USER_ID, userId);
        jsonObject.addProperty(SDP_ANSWER, ipSdpAnswer);
        return jsonObject;
    }
}
