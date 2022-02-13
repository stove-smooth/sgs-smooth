package com.example.communityserver.repository;

import com.example.communityserver.domain.CommunityInvitation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CommunityInvitationRepository extends JpaRepository<CommunityInvitation, Long> {
    List<CommunityInvitation> findByCode(String code);
}
