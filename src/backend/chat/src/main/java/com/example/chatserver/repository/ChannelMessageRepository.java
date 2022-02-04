package com.example.chatserver.repository;

import com.example.chatserver.domain.ChannelMessage;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;


public interface ChannelMessageRepository extends MongoRepository<ChannelMessage,String> {

    Page<ChannelMessage> findByChannelId(Long id, Pageable pageable);

    boolean existsById(String id);

}
