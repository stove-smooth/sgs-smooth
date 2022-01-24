package com.example.chatserver.config.message;

import com.example.chatserver.domain.ChannelMessage;
import com.example.chatserver.domain.DirectChat;
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
public class KafkaListenerConfig {

    @Value("${spring.kafka.bootstrap-servers}")
    private String bootstrapServers;

    private final String groupName = "chat-server-group";

    @Bean
    public ConcurrentKafkaListenerContainerFactory<String, DirectChat> kafkaListenerContainerFactory() {
        ConcurrentKafkaListenerContainerFactory<String,DirectChat> factory = new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(consumerFactory());
        return factory;
    }

    @Bean
    public ConsumerFactory<String, DirectChat> consumerFactory() {
        return new DefaultKafkaConsumerFactory<>(consumerConfigurations(), new StringDeserializer(), new JsonDeserializer<>(DirectChat.class));
    }

    @Bean
    public ConcurrentKafkaListenerContainerFactory<String, ChannelMessage> kafkaListenerContainerFactory2() {
        ConcurrentKafkaListenerContainerFactory<String,ChannelMessage> factory = new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(consumerFactory2());
        return factory;
    }

    @Bean
    public ConsumerFactory<String, ChannelMessage> consumerFactory2() {
        return new DefaultKafkaConsumerFactory<>(consumerConfigurations(), new StringDeserializer(), new JsonDeserializer<>(ChannelMessage.class));
    }

    @Bean
    public Map<String, Object> consumerConfigurations() {
        Map<String,Object> configurations = new HashMap<>();
        configurations.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        configurations.put(ConsumerConfig.GROUP_ID_CONFIG, groupName);
        configurations.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);
        configurations.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);

        return configurations;
    }
}
