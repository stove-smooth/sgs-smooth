package com.example.chatserver.kafka.consumer;

import com.example.chatserver.domain.ChannelMessage;
import com.example.chatserver.domain.DirectMessage;
import com.example.chatserver.dto.response.FileUploadResponse;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.kafka.config.ConcurrentKafkaListenerContainerFactory;
import org.springframework.kafka.core.ConsumerFactory;
import org.springframework.kafka.core.DefaultKafkaConsumerFactory;
import org.springframework.kafka.support.serializer.JsonDeserializer;

import java.util.HashMap;
import java.util.Map;

@EnableKafka
@Configuration
public class FileUploadListenerConfig {

    @Value("${spring.kafka.bootstrap-servers}")
    private String bootstrapServers;

    @Value("${spring.kafka.consumer.group-id.file-upload}")
    private String groupName;

    @Bean
    public ConcurrentKafkaListenerContainerFactory<String, FileUploadResponse> kafkaListenerContainerFactoryForFile() {
        ConcurrentKafkaListenerContainerFactory<String,FileUploadResponse> factory = new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(consumerFactoryForFile());
        return factory;
    }

    @Bean
    public ConsumerFactory<String, FileUploadResponse> consumerFactoryForFile() {
        return new DefaultKafkaConsumerFactory<>(consumerConfigurationsForFile(),new StringDeserializer(), new JsonDeserializer<>(FileUploadResponse.class));
    }

    @Bean
    public Map<String, Object> consumerConfigurationsForFile() {
        Map<String,Object> configurations = new HashMap<>();
        configurations.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        configurations.put(ConsumerConfig.GROUP_ID_CONFIG, groupName);
        configurations.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);
        configurations.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);

        return configurations;
    }
}
