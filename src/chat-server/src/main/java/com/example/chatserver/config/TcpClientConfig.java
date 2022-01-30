package com.example.chatserver.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.integration.channel.DirectChannel;
import org.springframework.integration.config.EnableIntegration;
import org.springframework.integration.dsl.IntegrationFlow;
import org.springframework.integration.dsl.IntegrationFlows;
import org.springframework.integration.dsl.Transformers;
import org.springframework.integration.ip.dsl.Tcp;
import org.springframework.integration.ip.tcp.connection.AbstractClientConnectionFactory;
import org.springframework.integration.ip.tcp.connection.CachingClientConnectionFactory;
import org.springframework.integration.ip.tcp.connection.TcpNioClientConnectionFactory;
import org.springframework.integration.ip.tcp.serializer.ByteArrayCrLfSerializer;
import org.springframework.messaging.MessageChannel;

//@Configuration
//@EnableIntegration
public class TcpClientConfig{

    @Value("${tcp.server.host}")
    private String host;

    @Value("${tcp.server.port}")
    private int port;

    @Value("${tcp.client.connection.poolSize}")
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
//
//    @Bean
//    @ServiceActivator(inputChannel = "outboundChannel")
//    public MessageHandler outboundGateway(AbstractClientConnectionFactory clientConnectionFactory) {
//        TcpOutboundGateway tcpOutboundGateway = new TcpOutboundGateway();
//        tcpOutboundGateway.setConnectionFactory(clientConnectionFactory);
//        return tcpOutboundGateway;
//    }

    public ByteArrayCrLfSerializer codec() {
        ByteArrayCrLfSerializer crLfSerializer = new ByteArrayCrLfSerializer();
        crLfSerializer.setMaxMessageSize(204800000);
        return crLfSerializer;
    }


}
