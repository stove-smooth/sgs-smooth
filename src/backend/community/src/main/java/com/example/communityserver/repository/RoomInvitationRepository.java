package com.example.communityserver.repository;

import com.example.communityserver.domain.RoomInvitation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface RoomInvitationRepository extends JpaRepository<RoomInvitation, Long> {
    List<RoomInvitation> findByCode(String code);
}
