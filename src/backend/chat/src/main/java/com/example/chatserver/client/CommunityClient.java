package com.example.chatserver.client;

import com.example.chatserver.dto.response.CommunityFeignResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;

@FeignClient(name = "CommunityFeign", url = "https://api.yoloyolo.org/community-server")
public interface CommunityClient {

    @GetMapping("/community/feign/{communityId}/member-id")
    CommunityFeignResponse getUserIds(@PathVariable(value = "communityId") Long communityId);

    @GetMapping("/room/feign/{roomId}/member-id")
    CommunityFeignResponse getUserIdsFromDM(@PathVariable(value = "roomId") Long roomId);

    @GetMapping("/community/feign/room-list/{userId}")
    List<String> getRoomList(@PathVariable(value = "userId") Long userId);
}
