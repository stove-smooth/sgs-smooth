package com.example.communityserver.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.List;

@FeignClient(name = "ChatFeign", url = "http://52.79.229.100:8000/chat-server")
public interface ChatClient {

    @PutMapping("/community-user-list/{community_id}")
    void updateCommunityMember(
            @PathVariable(value = "community_id") Long community_id,
            @RequestBody List<Long> ids
    );

    @PutMapping("/room-user-list/{room_id}")
    void updateRoomMember(
            @PathVariable(value = "room_id") Long room_id,
            @RequestBody List<Long> ids
    );
}
