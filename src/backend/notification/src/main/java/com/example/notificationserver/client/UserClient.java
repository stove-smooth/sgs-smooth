package com.example.notificationserver.client;

import com.example.notificationserver.dto.response.DeviceTokenResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.List;
import java.util.Map;

@FeignClient(name = "UserFeign", url = "http://52.79.229.100:8000/auth-server")
public interface UserClient {

    @PostMapping("/device-token")
    Map<Long, DeviceTokenResponse> getUserDeviceToken(@RequestBody List<Long> ids);
}
