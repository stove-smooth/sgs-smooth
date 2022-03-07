package com.example.notificationserver.controller;

import com.example.notificationserver.dto.request.RegisterRequest;
import com.example.notificationserver.dto.response.CommonResponse;
import com.example.notificationserver.dto.response.DataResponse;
import com.example.notificationserver.dto.response.DeviceResponse;
import com.example.notificationserver.service.DeviceService;
import com.example.notificationserver.service.ResponseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@Slf4j
@RestController
@RequestMapping("/notification-server/device")
@RequiredArgsConstructor
public class DeviceController {

    private final ResponseService responseService;
    private final DeviceService deviceService;

    @GetMapping("/{id}")
    public DataResponse<DeviceResponse> getDevice(@PathVariable("id") Long userId) {
        log.info("GET /notification-server/device/{}", userId);
        DeviceResponse response = deviceService.getDevice(userId);
        return responseService.getDataResponse(response);
    }

    @PostMapping
    public CommonResponse register(@Valid @RequestBody RegisterRequest request) {
        log.info("POST /notification-server/device");
        deviceService.register(request);
        return responseService.getSuccessResponse();
    }

    @DeleteMapping({"/{id}"})
    public CommonResponse delete(@PathVariable("id") Long userId) {
        log.info("DELETE /notification-server/device/{}", userId);
        deviceService.delete(userId);
        return responseService.getSuccessResponse();
    }
}