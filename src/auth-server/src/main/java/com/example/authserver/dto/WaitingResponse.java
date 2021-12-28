package com.example.authserver.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WaitingResponse {

    List<FriendResponse> toMe = new ArrayList<>();

    List<FriendResponse> toFriend = new ArrayList<>();
}
