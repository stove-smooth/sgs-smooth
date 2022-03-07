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
public class DeviceTokenResponse {
    @Enumerated(EnumType.STRING)
    private Platform platform;
    private String token;

    public static DeviceTokenResponse fromEntity(Device device) {
        DeviceTokenResponse response = new DeviceTokenResponse();
        response.setPlatform(device.getPlatform());
        response.setToken(device.getToken());
        return response;
    }
}
