package com.example.chatserver.controller;

import com.example.chatserver.configuration.message.MessageSender;
import com.example.chatserver.domain.ChannelMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;

@Slf4j
@RestController
@RequestMapping(value = "chat-server")
@RequiredArgsConstructor
public class ChannelChatController {

    private final String topicName = "channel-server-topic";

    private final MessageSender messageSender;

    @MessageMapping("/send-channel-message")
    public void sendMessage(@Payload ChannelMessage channelMessage) {
        channelMessage.setLocalDateTime(LocalDateTime.now());
        messageSender.send2(topicName, channelMessage);
    }
//
//    @GetMapping("/community")
//    public void community(@RequestParam(value = "com_id") Long com_id,
//                          @RequestParam(value = "ca_id") Long ca_id,
//                          )
}
