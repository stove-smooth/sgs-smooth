package com.example.communityserver.repository;

import com.example.communityserver.domain.CommunityMember;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CommunityMemberRepository extends JpaRepository<CommunityMember, Long> {
    List<CommunityMember> findByUserId(Long userId);
}
