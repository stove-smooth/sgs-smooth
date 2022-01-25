package com.example.communityserver.repository;

import com.example.communityserver.domain.RoomInvitation;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RoomInvitationRepository extends JpaRepository<RoomInvitation, Long> {
}
