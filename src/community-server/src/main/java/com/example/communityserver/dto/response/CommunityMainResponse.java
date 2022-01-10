package com.example.communityserver.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CommunityMainResponse {
    private List<RoomResponse> rooms;
    private List<CommunityResponse> communities;
    private CommunityDetailResponse community;
    private ChannelDetailResponse channel;
}
