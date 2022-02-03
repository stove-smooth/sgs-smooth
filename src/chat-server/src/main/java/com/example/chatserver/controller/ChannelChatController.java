package com.example.chatserver.controller;

import com.example.chatserver.client.PresenceClient;
import com.example.chatserver.config.S3Config;
import com.example.chatserver.config.TcpClientGateway;
import com.example.chatserver.config.message.MessageSender;
import com.example.chatserver.domain.ChannelMessage;
import com.example.chatserver.dto.request.FileUploadRequest;
import com.example.chatserver.dto.request.LoginSessionRequest;
import com.example.chatserver.dto.response.FileUploadResponse;
import com.example.chatserver.dto.response.MessageResponse;
import com.example.chatserver.dto.response.DataResponse;
import com.example.chatserver.repository.ChannelMessageRepository;
import com.example.chatserver.service.ChannelChatService;
import com.example.chatserver.service.ResponseService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;

@Slf4j
@RestController
@RequestMapping(value = "chat-server")
@RequiredArgsConstructor
public class ChannelChatController {

    @Value("${spring.kafka.consumer.direct-topic}")
    private String communityChatTopic;

    @Value("${spring.kafka.consumer.etc-community-topic}")
    private String etcCommunityTopic;

    @Value("${spring.kafka.consumer.file-topic}")
    private String fileTopic;

    private final MessageSender messageSender;
    private final ChannelChatService channelChatService;
    private final ResponseService responseService;
    private final TcpClientGateway tcpClientGateway;
    private final PresenceClient presenceClient;

    @MessageMapping("/send-channel-typing")
    public void sendTyping(@Payload ChannelMessage channelMessage) {
        messageSender.sendToEtcChannelChat(etcCommunityTopic,channelMessage);
    }

    @MessageMapping("/send-channel-message")
    public void sendMessage(@Payload ChannelMessage channelMessage) {
        channelMessage.setLocalDateTime(LocalDateTime.now());
        messageSender.sendToChannelChat(communityChatTopic, channelMessage);
    }

    @MessageMapping("/send-channel-reply")
    public void sendReplyMessage(@Payload ChannelMessage channelMessage) {
        messageSender.sendToEtcChannelChat(etcCommunityTopic,channelMessage);
    }

    @MessageMapping("/send-channel-modify")
    public void sendModifyMessage(@Payload ChannelMessage channelMessage) {
        messageSender.sendToEtcChannelChat(etcCommunityTopic,channelMessage);
    }

    @MessageMapping("/send-channel-delete")
    public void sendDeleteMessage(@Payload ChannelMessage channelMessage) {
        messageSender.sendToEtcChannelChat(etcCommunityTopic,channelMessage);
    }

    @MessageMapping("/join-channel")
    public void sendState(@Payload LoginSessionRequest loginSessionRequest) {
        presenceClient.changeState(loginSessionRequest);
    }

    @GetMapping("/community")
    public DataResponse<List<MessageResponse>> community(@RequestParam(value = "ch_id") Long ch_id,
                                                         @RequestParam(defaultValue = "0") int page,
                                                         @RequestParam(defaultValue = "50") int size) {

        return responseService.getDataResponse(channelChatService.findAllByPage(ch_id,page,size));
    }

    // todo kafka
    @PostMapping("/channel/file")
    public void sendFile(@ModelAttribute FileUploadRequest fileUploadRequest) throws IOException {
        FileUploadResponse uploadResponse = channelChatService.fileUpload(fileUploadRequest);
        messageSender.fileUpload(fileTopic,uploadResponse);

    }
}
