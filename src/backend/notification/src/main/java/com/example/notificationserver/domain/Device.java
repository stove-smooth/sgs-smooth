package com.example.notificationserver.domain;

import com.example.notificationserver.domain.type.Platform;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Table(name = "device")
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Device extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "device_id")
    private Long id;

    private Long userId;

    @Enumerated(EnumType.STRING)
    private Platform platform;

    private String token;

    private boolean status;

    // 생성 메서드
    public static Device register(Long userId, Platform platform, String token) {
        Device device = new Device();
        device.setUserId(userId);
        device.setPlatform(platform);
        device.setToken(token);
        device.setStatus(true);
        return device;
    }
    
    // 비즈니스 메서드
    public void renew(Platform platform, String token) {
        this.platform = platform;
        this.token = token;
        this.status = true;
    }

    public void delete() {
        this.status = false;
    }
}
