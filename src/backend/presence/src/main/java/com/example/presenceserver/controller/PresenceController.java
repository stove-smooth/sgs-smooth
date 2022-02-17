package com.example.presenceserver.controller;

import com.example.presenceserver.dto.request.LoginSessionRequest;
import com.example.presenceserver.dto.response.CommonResponse;
import com.example.presenceserver.dto.response.DataResponse;
import com.example.presenceserver.service.PresenceService;
import com.example.presenceserver.service.ResponseService;
import com.fasterxml.jackson.core.JsonProcessingException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping(value = "/presence-server")
public class PresenceController {

    private final ResponseService responseService;
    private final PresenceService presenceService;

    // 유저들 on, off 상태 정보 반환
    @GetMapping("/user-state")
    public Map<Long,String> getUsersState() {
        return presenceService.getUsersState();
    }

    @PostMapping("/friends-state")
    public DataResponse<Map<String,String>> getFriendsState(@RequestBody List<String> ids) {
        return responseService.getDataResponse(presenceService.getFriendsState(ids));
    }

    // 테스트 용
    @GetMapping("/for-me")
    public Map<String,String> getState () {
        return presenceService.getState();
    }

    // 테스트 용
    @GetMapping("/all-redis-info")
    public Map<String,String> allInfo() {
        return presenceService.allInfo();
    }

    // 테스트 용
    @GetMapping("/delete")
    public void delete() {
        presenceService.deleteAll();
    }
}
