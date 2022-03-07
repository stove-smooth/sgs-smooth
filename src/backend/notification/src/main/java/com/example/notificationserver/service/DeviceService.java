package com.example.notificationserver.service;

import com.example.notificationserver.domain.Device;
import com.example.notificationserver.dto.request.RegisterRequest;
import com.example.notificationserver.dto.response.DeviceResponse;
import com.example.notificationserver.exception.CustomException;
import com.example.notificationserver.repository.DeviceRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

import static com.example.notificationserver.exception.CustomExceptionStatus.EMPTY_DEVICE;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class DeviceService {

    private final DeviceRepository deviceRepository;

    public DeviceResponse getDevice(Long userId) {
        Device device = deviceRepository.findByUserId(userId)
                .orElseThrow(() -> new CustomException(EMPTY_DEVICE));
        return DeviceResponse.fromEntity(device);
    }

    @Transactional
    public void register(RegisterRequest request) {
        Optional<Device> device = deviceRepository.findByUserId(request.getUserId());

        if (device.isPresent()) {
            device.get().renew(request.getPlatform(), request.getToken());
            return;
        }

        Device newDevice = Device.register(request.getUserId(), request.getPlatform(), request.getToken());
        deviceRepository.save(newDevice);
    }


    @Transactional
    public void delete(Long userId) {
        Device device = deviceRepository.findByUserId(userId)
                .orElseThrow(() -> new CustomException(EMPTY_DEVICE));
        device.delete();
    }
}
