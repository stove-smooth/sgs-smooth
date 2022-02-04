package com.example.signalingserver.util.type;

public class Property {

    // event id
    public static final String JOIN = "joinRoom";
    public static final String NEW_PARTICIPANT_ARRIVED = "newParticipantArrived";
    public static final String RECEIVE_VIDEO_FROM = "receiveVideoFrom";
    public static final String RECEIVE_VIDEO_ANSWER = "receiveVideoAnswer";
    public static final String EXISTING_PARTICIPANTS = "existingParticipants";
    public static final String LEAVE = "leaveRoom";
    public static final String PARTICIPANT_LEFT = "participantLeft";
    public static final String ON_ICE_CANDIDATE = "onIceCandidate";
    public static final String ICE_CANDIDATE = "iceCandidate";

    // properties in event
    public static final String USER_ID = "userId";
    public static final String ROOM_ID = "roomId";
    public static final String MEMBERS = "members";
    public static final String SENDER = "sender";
    public static final String SDP_OFFER = "sdpOffer";
    public static final String SDP_ANSWER = "sdpAnswer";
    public static final String CANDIDATE = "candidate";
    public static final String SDP_MID = "sdpMid";
    public static final String SDP_M_LINE_INDEX = "sdpMLineIndex";
}
