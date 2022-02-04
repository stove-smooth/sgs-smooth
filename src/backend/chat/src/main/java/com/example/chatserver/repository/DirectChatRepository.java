package com.example.chatserver.repository;

import com.example.chatserver.domain.DirectChat;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface DirectChatRepository extends MongoRepository<DirectChat, String> {

    Page<DirectChat> findByChannelId(Long ch_id, Pageable paging);
}
