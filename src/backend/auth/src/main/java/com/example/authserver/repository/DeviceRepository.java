package com.example.authserver.repository;

import com.example.authserver.domain.Device;
import com.example.authserver.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface DeviceRepository extends JpaRepository<Device,Long> {
    @Query(nativeQuery = true, value = "SELECT * FROM device as a WHERE a.user_id in (:id)")
    Device findByUserId(Long id);

    @Query(nativeQuery = true, value = "SELECT * FROM device as a WHERE a.user_id in (:ids)")
    List<Device> findByUserId(List<Long> ids);
}
