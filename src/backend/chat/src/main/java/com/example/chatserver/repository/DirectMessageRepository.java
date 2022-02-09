package com.example.chatserver.repository;

import com.example.chatserver.domain.DirectMessage;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.time.LocalDateTime;
import java.util.List;

public interface DirectMessageRepository extends MongoRepository<DirectMessage, String> {

    Page<DirectMessage> findByChannelId(Long ch_id, Pageable paging);
    List<DirectMessage> findByChannelIdAndLocalDateTimeBetween(Long channelId, LocalDateTime start, LocalDateTime end);
}
