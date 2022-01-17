package com.example.presenceserver.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class TcpService {

    public byte[] processMessage(byte[] message) {
        String messageContent = new String(message);
        log.info("Receive message: {}", messageContent);
        String responseContent = String.format("Message \"%s\" is processed", messageContent);
        return responseContent.getBytes();
    }
}
