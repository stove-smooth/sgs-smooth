package com.example.signalingserver.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ParticipantInfoResponse {
    private String userId;
    private boolean video;
    private boolean audio;
}
