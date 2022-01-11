package com.example.communityserver.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotNull;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class CreateInvitationRequest {

    @NotNull
    private int validTime;

    @NotNull
    private int count;

    @NotNull
    private Long channelId;
}
