package com.example.authserver.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Device {

    @Id @GeneratedValue
    @Column(name = "device_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @Column(length = 20)
    private String type;

    @Column(length = 200)
    private String token;

    private LocalDateTime access_time;

    private LocalDateTime last_access;

    public void setLast_access(LocalDateTime last_access) {
        this.last_access = last_access;
    }
}
