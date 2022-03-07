package com.example.notificationserver.dto.response;

import com.example.notificationserver.domain.Device;
import com.example.notificationserver.domain.type.Platform;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.EnumType;
import javax.persistence.Enumerated;

@Getter
@Setter
@NoArgsConstructor
public class DeviceResponse {

    private Long userId;

    @Enumerated(EnumType.STRING)
    private Platform platform;

    private String token;

    private boolean status;

    public static DeviceResponse fromEntity(Device device) {
        DeviceResponse response = new DeviceResponse();
        response.setUserId(device.getUserId());
        response.setPlatform(device.getPlatform());
        response.setToken(device.getToken());
        response.setStatus(device.isStatus());
        return response;
    }
}
