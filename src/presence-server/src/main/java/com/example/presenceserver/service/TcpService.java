package com.example.presenceserver.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class TcpService {

    public String processMessage(String message) {
        log.info("Receive message: {}", message);
        return "반환메세지";
    }

    public String processMessage2(String message, String type) {
        log.info(message);
        log.info(type);
        return "dd";
    }
}
