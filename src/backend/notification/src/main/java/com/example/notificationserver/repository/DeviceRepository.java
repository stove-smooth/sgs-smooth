package com.example.notificationserver.repository;

import com.example.notificationserver.domain.Device;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface DeviceRepository extends JpaRepository<Device, Long> {
    Optional<Device> findByUserId(Long userId);

    @Query(nativeQuery = true, value = "SELECT * FROM Device as d WHERE d.userId IN (:userIds)")
    List<Device> findByUserIdList(@Param("userIds") List<Long> userIds);
}
