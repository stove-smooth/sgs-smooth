package com.example.communityserver.repository;

import com.example.communityserver.domain.CommunityInvitation;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CommunityInvitationRepository extends JpaRepository<CommunityInvitation, Long> {
}
