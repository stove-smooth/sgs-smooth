package com.example.chatserver.repository;


import com.example.chatserver.domain.MessageTime;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface MessageTimeRepository extends MongoRepository<MessageTime,String> {
    MessageTime findByChannelId(String channelId);
}
