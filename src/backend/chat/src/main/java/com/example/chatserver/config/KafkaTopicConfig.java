package com.example.chatserver.config;

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
    private String directChatTopic;

    @Value("${spring.kafka.consumer.direct-topic}")
    private String communityChatTopic;

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
    public NewTopic directChat() {
        return new NewTopic(directChatTopic,3, (short) 3);
    }

    @Bean
    public NewTopic etcDirectChat() {
        return new NewTopic(etcDirectTopic,3,(short) 3);
    }

    @Bean
    public NewTopic communityChat() {
        return new NewTopic(communityChatTopic,3, (short) 3);
    }

    @Bean
    public NewTopic etcCommunityChat() {
        return new NewTopic(etcCommunityTopic,3,(short) 3);
    }

    @Bean
    public NewTopic fileUpload() {
        return new NewTopic(fileTopic,3, (short) 3);
    }
}
