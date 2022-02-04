package com.example.signalingserver.config;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;
import org.springframework.web.socket.server.standard.ServletServerContainerFactoryBean;

import javax.servlet.ServletContext;
import javax.websocket.server.ServerContainer;

@Configuration
@RequiredArgsConstructor
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {

    @Value("${property.ignoreNullWsContainer}")
    private boolean ignoreNullWsContainer;

    private final MessageHandler messageHandler;

    private static final int MESSAGE_BUFFER_SIZE = 8192;

    private final ServletContext servletContext;

    @Bean
    public ServletServerContainerFactoryBean createServletServerContainerFactoryBean() {
        if (ignoreNullWsContainer) {
            ServerContainer serverContainer =
                    (ServerContainer) this.servletContext.getAttribute("javax.websocket.server.ServerContainer");
            if (serverContainer == null) {
                return null;
            }
        }

        ServletServerContainerFactoryBean container = new ServletServerContainerFactoryBean();
        container.setMaxTextMessageBufferSize(MESSAGE_BUFFER_SIZE);
        container.setMaxBinaryMessageBufferSize(MESSAGE_BUFFER_SIZE);
        return container;
    }

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(messageHandler, "/rtc")
                .setAllowedOriginPatterns("*")
                .withSockJS();
    }
}
