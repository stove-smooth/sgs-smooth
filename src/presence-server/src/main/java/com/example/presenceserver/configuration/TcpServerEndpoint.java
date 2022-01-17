package com.example.presenceserver.configuration;

import com.example.presenceserver.service.TcpService;
import lombok.RequiredArgsConstructor;
import org.springframework.integration.annotation.MessageEndpoint;
import org.springframework.integration.annotation.ServiceActivator;

@MessageEndpoint
@RequiredArgsConstructor
public class TcpServerEndpoint {

    private final TcpService tcpService;


    @ServiceActivator(inputChannel = "inboundChannel")
    public byte[] process(byte[] message) {
        return tcpService.processMessage(message);
    }

}
