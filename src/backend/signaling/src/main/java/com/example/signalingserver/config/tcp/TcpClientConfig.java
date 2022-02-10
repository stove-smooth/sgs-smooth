package com.example.signalingserver.config.tcp;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.integration.channel.DirectChannel;
import org.springframework.integration.config.EnableIntegration;
import org.springframework.integration.dsl.IntegrationFlow;
import org.springframework.integration.dsl.IntegrationFlows;
import org.springframework.integration.dsl.Transformers;
import org.springframework.integration.ip.dsl.Tcp;
import org.springframework.integration.ip.tcp.connection.*;
import org.springframework.integration.ip.tcp.serializer.ByteArrayCrLfSerializer;
import org.springframework.messaging.MessageChannel;

@Configuration
@EnableIntegration
public class TcpClientConfig {

    @Value("${tcp.server.host}")
    private String host;

    @Value("${tcp.server.port}")
    private int port;

    @Value("${tcp.server.connection.pool-size}")
    private int connectionPoolSize;

    @Bean
    public AbstractClientConnectionFactory clientConnectionFactory() {
        TcpNioClientConnectionFactory tcpNioClientConnectionFactory = new TcpNioClientConnectionFactory(host, port);
        tcpNioClientConnectionFactory.setUsingDirectBuffers(true);
        tcpNioClientConnectionFactory.setSerializer(codec());
        tcpNioClientConnectionFactory.setDeserializer(codec());
        return new CachingClientConnectionFactory(tcpNioClientConnectionFactory, connectionPoolSize);
    }

    @Bean
    public IntegrationFlow fileWriterFlow() {
        return IntegrationFlows.from("outboundChannel")
                .handle(Tcp.outboundGateway(clientConnectionFactory()))
                .transform(Transformers.objectToString()).get();
    }

    @Bean
    public MessageChannel outboundChannel() {
        return new DirectChannel();
    }

    public ByteArrayCrLfSerializer codec() {
        ByteArrayCrLfSerializer crLfSerializer = new ByteArrayCrLfSerializer();
        crLfSerializer.setMaxMessageSize(204800000);
        return crLfSerializer;
    }
}