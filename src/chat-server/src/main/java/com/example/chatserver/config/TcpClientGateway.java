package com.example.chatserver.config;

import org.springframework.integration.annotation.MessagingGateway;
import org.springframework.stereotype.Component;

//@Component
//@MessagingGateway(defaultRequestChannel = "outboundChannel")
public interface TcpClientGateway {

    String send(String message);

}
