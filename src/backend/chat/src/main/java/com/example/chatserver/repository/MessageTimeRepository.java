package com.example.chatserver.repository;


import com.example.chatserver.domain.MessageTime;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface MessageTimeRepository extends MongoRepository<MessageTime,String> {
    MessageTime findByChannelId(String channelId);
}
