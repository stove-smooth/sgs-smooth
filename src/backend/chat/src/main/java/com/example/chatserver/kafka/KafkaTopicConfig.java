package com.example.chatserver.kafka;

import org.apache.kafka.clients.admin.AdminClientConfig;
import org.apache.kafka.clients.admin.NewTopic;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.core.KafkaAdmin;

import java.util.HashMap;
import java.util.Map;

@Configuration
public class KafkaTopicConfig {

    @Value("${spring.kafka.bootstrap-servers}")
    private String bootstrapServers;

    @Value("${spring.kafka.consumer.chat-topic}")
    private String directMessageTopic;

    @Value("${spring.kafka.consumer.direct-topic}")
    private String communityMessageTopic;

    @Value("${spring.kafka.consumer.etc-direct-topic}")
    private String etcDirectTopic;

    @Value("${spring.kafka.consumer.etc-community-topic}")
    private String etcCommunityTopic;

    @Value("${spring.kafka.consumer.file-topic}")
    private String fileTopic;

    @Bean
    public KafkaAdmin kafkaAdmin() {
        Map<String,Object> configs = new HashMap<>();
        configs.put(AdminClientConfig.BOOTSTRAP_SERVERS_CONFIG,bootstrapServers);
        return new KafkaAdmin(configs);
    }

    @Bean
    public NewTopic directMessage() {
        return new NewTopic(directMessageTopic,3, (short) 3);
    }

    @Bean
    public NewTopic etcDirectMessage() {
        return new NewTopic(etcDirectTopic,3,(short) 3);
    }

    @Bean
    public NewTopic communityMessage() {
        return new NewTopic(communityMessageTopic,3, (short) 3);
    }

    @Bean
    public NewTopic etcCommunityMessage() {
        return new NewTopic(etcCommunityTopic,3,(short) 3);
    }

    @Bean
    public NewTopic fileUpload() {
        return new NewTopic(fileTopic,3, (short) 3);
    }
}
