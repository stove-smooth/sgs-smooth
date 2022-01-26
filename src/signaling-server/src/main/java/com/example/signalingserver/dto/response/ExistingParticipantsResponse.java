package com.example.signalingserver.dto.response;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class ExistingParticipantsResponse {
    private String id;
    private List<String> members;

    public ExistingParticipantsResponse(List<String> members) {
        this.id = "existingParticipants";
        this.members = members;
    }
}
