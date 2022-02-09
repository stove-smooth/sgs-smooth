package com.example.communityserver.repository;

import com.example.communityserver.domain.Channel;
import org.springframework.data.jpa.repository.JpaRepository;


public interface ChannelRepository extends JpaRepository<Channel, Long> {
}
