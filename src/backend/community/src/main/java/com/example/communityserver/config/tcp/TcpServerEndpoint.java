package com.example.communityserver.config.tcp;

import com.example.communityserver.service.MessageService;
import com.fasterxml.jackson.core.JsonProcessingException;
import lombok.RequiredArgsConstructor;
import org.springframework.integration.annotation.MessageEndpoint;
import org.springframework.integration.annotation.ServiceActivator;

@MessageEndpoint
@RequiredArgsConstructor
public class TcpServerEndpoint {

    private final MessageService messageService;

    @ServiceActivator(inputChannel = "inboundChannel", async = "true")
    public String process(String message) {
        return messageService.processMessage(message);
    }
}
