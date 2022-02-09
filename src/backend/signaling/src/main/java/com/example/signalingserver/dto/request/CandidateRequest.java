package com.example.signalingserver.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CandidateRequest {
    private String id;
    private String userId;
    private Candidate candidate;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Candidate {
        private String candidate;
        private String sdpMid;
        private int sdpMLineIndex;
    }
}
