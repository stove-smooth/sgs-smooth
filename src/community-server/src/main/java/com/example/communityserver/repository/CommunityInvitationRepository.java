package com.example.communityserver.repository;

import com.example.communityserver.domain.CommunityInvitation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface CommunityInvitationRepository extends JpaRepository<CommunityInvitation, Long> {
    Optional<CommunityInvitation> findByCode(String code);
}
