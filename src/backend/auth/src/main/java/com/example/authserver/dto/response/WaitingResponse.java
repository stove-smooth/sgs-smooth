package com.example.authserver.dto.response;

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

    List<FriendResponse> receiveFromFriend = new ArrayList<>();

    List<FriendResponse> sendToFriend = new ArrayList<>();
}
