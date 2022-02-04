package com.example.chatserver.config.message;

import com.example.chatserver.domain.ChannelMessage;
import com.example.chatserver.domain.DirectChat;
import com.example.chatserver.dto.request.FileUploadRequest;
import com.example.chatserver.dto.response.FileUploadResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class MessageSender {

    private final KafkaTemplate<String, DirectChat> kafkaTemplateForDirectChat;

    private final KafkaTemplate<String, ChannelMessage> kafkaTemplateForChannelChat;

    private final KafkaTemplate<String, FileUploadResponse> kafkaTemplateForFileUpload;

    public void sendToDirectChat(String topic, DirectChat directChat) {
        kafkaTemplateForDirectChat.send(topic,directChat);
    }

    public void sendToChannelChat(String topic,ChannelMessage channelMessage) {
        kafkaTemplateForChannelChat.send(topic,channelMessage);
    }

    public void sendToEtcDirectChat(String topic, DirectChat directChat) {
        kafkaTemplateForDirectChat.send(topic,directChat);

    }
    public void sendToEtcChannelChat(String topic, ChannelMessage channelMessage) {
        kafkaTemplateForChannelChat.send(topic,channelMessage);
    }

    public void fileUpload(String topic, FileUploadResponse fileUploadResponse) {
        kafkaTemplateForFileUpload.send(topic,fileUploadResponse);
    }
}
