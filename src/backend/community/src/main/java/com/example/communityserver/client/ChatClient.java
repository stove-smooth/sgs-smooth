package com.example.communityserver.client;

import com.example.communityserver.dto.request.MemberUpdateFeignRequest;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient(name = "ChatFeign", url = "http://52.79.229.100:8000/chat-server")
public interface ChatClient {

    @PutMapping("/community-user-list/{community_id}")
    void updateCommunityMember(
            @PathVariable(value = "community_id") Long community_id,
            @RequestBody MemberUpdateFeignRequest request
    );

    @PutMapping("/room-user-list/{room_id}")
    void updateRoomMember(
            @PathVariable(value = "room_id") Long room_id,
            @RequestBody MemberUpdateFeignRequest request
    );
}
