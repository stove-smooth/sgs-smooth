package com.example.chatserver.client;

import com.example.chatserver.dto.response.CommunityFeignResponse;
import com.example.chatserver.dto.response.UserInfoFeignResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

//@FeignClient(name = "CommunityFeign", url = "http://52.79.229.100:8000/community-server")
@FeignClient(name = "CommunityFeign", url = "http://localhost:8000/community-server")
public interface CommunityClient {

    @GetMapping("/community/feign/{communityId}/member-id")
    CommunityFeignResponse getUserIds(@PathVariable(value = "communityId") Long communityId);
}
