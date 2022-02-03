package com.example.chatserver.config.message;

import com.example.chatserver.domain.ChannelMessage;
import com.example.chatserver.domain.DirectChat;
import com.example.chatserver.dto.request.FileUploadRequest;
import com.example.chatserver.dto.response.FileUploadResponse;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.common.serialization.StringSerializer;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.kafka.core.DefaultKafkaProducerFactory;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.core.ProducerFactory;
import org.springframework.kafka.support.serializer.JsonSerializer;

import java.util.HashMap;
import java.util.Map;

@EnableKafka
@Configuration
public class KafkaProducerConfig {

    @Value("${spring.kafka.bootstrap-servers}")
    private String bootstrapServers;

    public ProducerFactory<String, DirectChat> producerFactoryForDirect() {
        return new DefaultKafkaProducerFactory<>(producerConfigurations());
    }

    public ProducerFactory<String, ChannelMessage> producerFactoryForCommunity() {
        return new DefaultKafkaProducerFactory<>(producerConfigurations());
    }

    public ProducerFactory<String, FileUploadResponse> producerFactoryForFileUpload() {
        return new DefaultKafkaProducerFactory<>(producerConfigurations());
    }

    @Bean
    public Map<String,Object> producerConfigurations() {
        Map<String,Object> configurations = new HashMap<>();
        configurations.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG,bootstrapServers);
        configurations.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
        configurations.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, JsonSerializer.class);
        return configurations;
    }

    @Bean
    public KafkaTemplate<String, DirectChat> kafkaTemplateForDirect() {
        return new KafkaTemplate<>(producerFactoryForDirect());
    }

    @Bean
    public KafkaTemplate<String, ChannelMessage> kafkaTemplateForCommunity() {
        return new KafkaTemplate<>(producerFactoryForCommunity());
    }

    @Bean
    KafkaTemplate<String,FileUploadResponse> kafkaTemplateForFileUpload() {
        return new KafkaTemplate<>(producerFactoryForFileUpload());
    }
}
