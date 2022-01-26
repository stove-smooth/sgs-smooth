package com.example.signalingserver.dto.response;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ParticipantArrivedResponse {
    private String id;
    private String userId;
    private String source;

    public ParticipantArrivedResponse(String userId, String source) {
        this.id = "newParticipantArrived";
        this.userId = userId;
        this.source = source;
    }
}
