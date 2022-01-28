package com.example.signalingserver.domain;

import com.google.gson.JsonObject;
import lombok.extern.slf4j.Slf4j;
import org.kurento.client.*;
import org.kurento.jsonrpc.JsonUtils;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import java.io.Closeable;
import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

import static com.example.signalingserver.util.type.Message.iceCandidate;
import static com.example.signalingserver.util.type.Message.receiveVideoAnswer;

@Slf4j
public class UserSession implements Closeable {

    private final String userId;
    private final WebSocketSession session;

    private final MediaPipeline pipeline;

    private final String roomId;
    private final WebRtcEndpoint outgoingMedia;
    private final ConcurrentMap<String, WebRtcEndpoint> incomingMedia = new ConcurrentHashMap<>();

    public UserSession(String userId, String roomId, WebSocketSession session, MediaPipeline pipeline) {

        this.userId = userId;
        this.session = session;
        this.pipeline = pipeline;
        this.roomId = roomId;
        this.outgoingMedia = new WebRtcEndpoint.Builder(pipeline).build();
        this.outgoingMedia.addIceCandidateFoundListener(new EventListener<IceCandidateFoundEvent>() {

            @Override
            public void onEvent(IceCandidateFoundEvent event) {
                JsonObject response = iceCandidate(userId, JsonUtils.toJsonObject(event.getCandidate()));
                try {
                    synchronized (session) {
                        session.sendMessage(new TextMessage(response.toString()));
                    }
                } catch (IOException e) {
                    log.debug(e.getMessage());
                }
            }
        });
    }

    public WebRtcEndpoint getOutgoingWebRtcPeer() {
        return outgoingMedia;
    }

    public String getUserId() {
        return this.userId;
    }

    public WebSocketSession getSession() {
        return this.session;
    }

    public String getRoomId() {
        return this.roomId;
    }

    public void receiveVideoFrom(UserSession sender, String sdpOffer) throws IOException {
        final String ipSdpAnswer = this.getEndpointForUser(sender).processOffer(sdpOffer);
        final JsonObject scParams = receiveVideoAnswer(sender.getUserId(), ipSdpAnswer);
        this.sendMessage(scParams);
        this.getEndpointForUser(sender).gatherCandidates();
    }

    public WebRtcEndpoint getEndpointForUser(final UserSession sender) {
        if (sender.getUserId().equals(userId)) {
            return outgoingMedia;
        }

        WebRtcEndpoint incoming = incomingMedia.get(sender.getUserId());
        if (incoming == null) {
            incoming = new WebRtcEndpoint.Builder(pipeline).build();
            incoming.addIceCandidateFoundListener(new EventListener<IceCandidateFoundEvent>() {

                @Override
                public void onEvent(IceCandidateFoundEvent event) {
                    JsonObject response = iceCandidate(sender.getUserId(), JsonUtils.toJsonObject(event.getCandidate()));
                    try {
                        synchronized (session) {
                            session.sendMessage(new TextMessage(response.toString()));
                        }
                    } catch (IOException e) {
                        log.debug(e.getMessage());
                    }
                }
            });
            incomingMedia.put(sender.getUserId(), incoming);
        }

        sender.getOutgoingWebRtcPeer().connect(incoming);
        return incoming;
    }

    public void cancelVideoFrom(final UserSession sender) {
        this.cancelVideoFrom(sender.getUserId());
    }

    public void cancelVideoFrom(final String senderName) {
        final WebRtcEndpoint incoming = incomingMedia.remove(senderName);

        incoming.release(new Continuation<Void>() {
            @Override
            public void onSuccess(Void result) throws Exception { }
            @Override
            public void onError(Throwable cause) throws Exception { }
        });
    }

    @Override
    public void close() throws IOException {
        for (final String remoteParticipantName : incomingMedia.keySet()) {
            final WebRtcEndpoint ep = this.incomingMedia.get(remoteParticipantName);
            ep.release(new Continuation<Void>() {
                @Override
                public void onSuccess(Void result) throws Exception { }
                @Override
                public void onError(Throwable cause) throws Exception { }
            });
        }

        outgoingMedia.release(new Continuation<Void>() {
            @Override
            public void onSuccess(Void result) throws Exception { }
            @Override
            public void onError(Throwable cause) throws Exception { }
        });
    }

    public void sendMessage(JsonObject message) throws IOException {
        synchronized (session) {
            session.sendMessage(new TextMessage(message.toString()));
        }
    }

    public void addCandidate(IceCandidate candidate, String userId) {
        if (this.userId.compareTo(userId) == 0) {
            outgoingMedia.addIceCandidate(candidate);
        } else {
            WebRtcEndpoint webRtc = incomingMedia.get(userId);
            if (webRtc != null) {
                webRtc.addIceCandidate(candidate);
            }
        }
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || !(obj instanceof UserSession)) {
            return false;
        }
        UserSession other = (UserSession) obj;
        boolean eq = userId.equals(other.userId);
        eq &= roomId.equals(other.roomId);
        return eq;
    }

    @Override
    public int hashCode() {
        int result = 1;
        result = 31 * result + userId.hashCode();
        result = 31 * result + roomId.hashCode();
        return result;
    }
}