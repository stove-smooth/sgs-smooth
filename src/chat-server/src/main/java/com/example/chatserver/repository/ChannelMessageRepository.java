package com.example.chatserver.repository;

import com.example.chatserver.domain.ChannelMessage;
import org.bson.types.ObjectId;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

import java.util.Optional;


public interface ChannelMessageRepository extends MongoRepository<ChannelMessage,String> {

    Page<ChannelMessage> findByChannelId(Long id, Pageable pageable);

}
