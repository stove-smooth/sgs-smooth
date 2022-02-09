package com.example.notificationserver.repository;

import com.example.notificationserver.domain.Notification;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface NotificationRepository extends MongoRepository<Notification, String> {
}
