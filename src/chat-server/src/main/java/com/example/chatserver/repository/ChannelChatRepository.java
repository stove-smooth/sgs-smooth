package com.example.chatserver.repository;

import com.example.chatserver.domain.ChannelMessage;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface ChannelChatRepository extends MongoRepository<ChannelMessage,String> {
}
