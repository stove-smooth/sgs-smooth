package com.example.presenceserver.config.client;

import org.springframework.integration.annotation.MessagingGateway;
import org.springframework.stereotype.Component;

@Component
@MessagingGateway(defaultRequestChannel = "communityChannel")
public interface TcpClientGateway {

    String send(String message);

}
