package com.example.notificationserver.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.messaging.FirebaseMessaging;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import java.io.IOException;
import java.util.Arrays;

@Configuration
public class FcmConfig {

    @Value("${fcm.firebase-create-scoped}")
    private String fireBaseCreateScoped;

    @Value("${fcm.key}")
    private String key;

    @Bean
    public FirebaseMessaging init() throws IOException {
        GoogleCredentials googleCredentials = GoogleCredentials.fromStream(new ClassPathResource(key).getInputStream())
                .createScoped((Arrays.asList(fireBaseCreateScoped)));

        FirebaseOptions secondaryAppConfig = FirebaseOptions.builder()
                .setCredentials(googleCredentials)
                .build();
        FirebaseApp app = FirebaseApp.initializeApp(secondaryAppConfig);
        return FirebaseMessaging.getInstance(app);
    }
}
