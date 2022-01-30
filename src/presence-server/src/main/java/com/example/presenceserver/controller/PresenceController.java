package com.example.presenceserver.controller;

import com.example.presenceserver.dto.request.LoginSessionRequest;
import com.example.presenceserver.dto.response.CommonResponse;
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

    @PostMapping("login-state")
    public CommonResponse uploadState(@RequestBody LoginSessionRequest loginSessionRequest) {
        presenceService.uploadState(loginSessionRequest);

        return responseService.getSuccessResponse();
    }

    @PostMapping("/logout-state")
    public CommonResponse deleteState(@RequestBody LoginSessionRequest loginSessionRequest) throws JsonProcessingException {

        presenceService.deleteState(loginSessionRequest);

        return responseService.getSuccessResponse();
    }

    @PostMapping("/change-state")
    public CommonResponse changeState(@RequestBody LoginSessionRequest loginSessionRequest) throws JsonProcessingException {
        presenceService.changeState(loginSessionRequest);

        return responseService.getSuccessResponse();
    }

    @PostMapping("/read")
    public Map<Long,Boolean> read(@RequestBody List<Long> requestAccountIds) {
        return presenceService.findRead(requestAccountIds);
    }

}
