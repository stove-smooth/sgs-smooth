package com.example.chatserver.controller;

import com.example.chatserver.configuration.message.MessageSender;
import com.example.chatserver.configuration.S3Config;
import com.example.chatserver.domain.DirectChat;
import com.example.chatserver.repository.MessageRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;


@Slf4j
@RestController
@RequestMapping(value = "chat-server")
@RequiredArgsConstructor
public class ChatController {

    private final String topicName = "chat-server-topic";

    private final MessageSender messageSender;

    private final S3Config s3Config;

    private final SimpMessagingTemplate template;

    private final MessageRepository messageRepository;

    @MessageMapping("/send-message")
//    @SendTo("/topic/group")
    public void sendMessage(@Payload DirectChat directChat) {
        directChat.setDateTime(LocalDateTime.now());
        messageSender.send(topicName,directChat);
    }
    @PostMapping("/file")
    public void sendFile(@RequestParam("image") MultipartFile multipartFile) throws IOException {
        String upload = s3Config.upload(multipartFile);

        DirectChat directChat = DirectChat.builder()
                .content(upload)
                .dateTime(LocalDateTime.now()).build();

        messageRepository.save(directChat);

        HashMap<String,String> msg = new HashMap<>();
        msg.put("name","병찬");
        msg.put("message",upload);
        msg.put("time", String.valueOf(LocalDateTime.now()));

        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(msg);
        template.convertAndSend("/topic/group", json);

    }
}
