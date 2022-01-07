package com.example.chatserver.repository;

import com.example.chatserver.domain.DirectChat;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MessageRepository extends MongoRepository<DirectChat, Long> {
}
