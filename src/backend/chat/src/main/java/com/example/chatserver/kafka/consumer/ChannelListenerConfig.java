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
public class ChannelListenerConfig {

    @Value("${spring.kafka.bootstrap-servers}")
    private String bootstrapServers;

    private final String groupName = "channel-server-group";

    @Bean
    public ConcurrentKafkaListenerContainerFactory<String, ChannelMessage> communityFactory() {
        ConcurrentKafkaListenerContainerFactory<String,ChannelMessage> factory = new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(consumerFactoryForCommunity());
        return factory;
    }

    @Bean
    public ConsumerFactory<String, ChannelMessage> consumerFactoryForCommunity() {
        return new DefaultKafkaConsumerFactory<>(consumerConfigurationsForCommunity(), new StringDeserializer(), new JsonDeserializer<>(ChannelMessage.class));
    }

    @Bean
    public Map<String, Object> consumerConfigurationsForCommunity() {
        Map<String,Object> configurations = new HashMap<>();
        configurations.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        configurations.put(ConsumerConfig.GROUP_ID_CONFIG, groupName);
        configurations.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);
        configurations.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);

        return configurations;
    }
}
