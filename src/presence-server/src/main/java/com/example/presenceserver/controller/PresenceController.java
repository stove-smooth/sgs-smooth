package com.example.presenceserver.controller;

import com.example.presenceserver.dto.request.LoginSessionRequest;
import com.example.presenceserver.dto.response.CommonResponse;
import com.example.presenceserver.service.PresenceService;
import com.example.presenceserver.service.ResponseService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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
    public CommonResponse deleteState(@RequestBody LoginSessionRequest loginSessionRequest) {

        presenceService.deleteState(loginSessionRequest);

        return responseService.getSuccessResponse();
    }
}
