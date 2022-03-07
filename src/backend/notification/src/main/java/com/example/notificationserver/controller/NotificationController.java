package com.example.notificationserver.controller;

import com.example.notificationserver.dto.request.ChannelMessageRequest;
import com.example.notificationserver.dto.request.DirectMessageRequest;
import com.example.notificationserver.dto.response.CommonResponse;
import com.example.notificationserver.service.NotificationService;
import com.example.notificationserver.service.ResponseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@Slf4j
@RestController
@RequestMapping("/notification-server")
@RequiredArgsConstructor
public class NotificationController {

    private final ResponseService responseService;
    private final NotificationService notificationService;

    @PostMapping("/direct")
    public CommonResponse sendDirectMessage(@Valid @RequestBody DirectMessageRequest request) {
        log.info("POST /notification-server/direct / {}", request.getTarget());
        try {
            notificationService.send(request);
        } catch (Exception e) {
            log.error("NOTIFICATION ERROR - DM");
            e.printStackTrace();
        }
        return responseService.getSuccessResponse();
    }

    @PostMapping("/channel")
    public CommonResponse sendChannelMessage(@Valid @RequestBody ChannelMessageRequest request) {
        log.info("POST /notification-server/channel / {}", request.getTarget());
        try {
            notificationService.send(request);
        } catch (Exception e) {
            log.error("NOTIFICATION ERROR - CHANNEL");
            e.printStackTrace();
        }
        return responseService.getSuccessResponse();
    }
}
