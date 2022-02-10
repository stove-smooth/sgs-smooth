package com.example.communityserver.client;

import com.example.communityserver.dto.request.MessageCountRequest;
import com.example.communityserver.dto.response.MessageCountResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

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

    @PostMapping("message-count")
    List<MessageCountResponse> getMyMessages(@RequestBody MessageCountRequest request);
}
