package com.example.chatserver.controller;

import com.example.chatserver.config.message.MessageSender;
import com.example.chatserver.config.S3Config;
import com.example.chatserver.domain.DirectChat;
import com.example.chatserver.dto.response.MessageResponse;
import com.example.chatserver.dto.response.DataResponse;
import com.example.chatserver.repository.DirectChatRepository;
import com.example.chatserver.service.DirectChatService;
import com.example.chatserver.service.ResponseService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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
public class DirectChatController {

    private final String topicName = "chat-server-topic";
    private final MessageSender messageSender;
    private final S3Config s3Config;
    private final SimpMessagingTemplate template;
    private final DirectChatService directChatService;
    private final DirectChatRepository messageRepository;
    private final ResponseService responseService;

    @MessageMapping("/send-direct-message")
    public void sendMessage(@Payload DirectChat directChat) {
        directChat.setLocalDateTime(LocalDateTime.now());
        messageSender.send(topicName,directChat);
    }
    @MessageMapping("/send-direct-modify")
    public void sendDirectMessage(@Payload DirectChat directChat) throws JsonProcessingException {
        HashMap<String, String> msg = directChatService.modifyMessage(directChat);
        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(msg);
        template.convertAndSend("/topic/direct/" + directChat.getChannelId(), json);
    }
    @MessageMapping("/send-direct-delete")
    public void sendDeleteMessage(@Payload DirectChat directChat) throws JsonProcessingException {
        HashMap<String, String> msg = directChatService.deleteMessage(directChat);
        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(msg);
        template.convertAndSend("/topic/direct/" + directChat.getChannelId(), json);
    }

    @GetMapping("/direct")
    public DataResponse<List<MessageResponse>> community(@RequestParam(value = "ch_id") Long ch_id,
                                                         @RequestParam(defaultValue = "0") int page,
                                                         @RequestParam(defaultValue = "50") int size) {

        return responseService.getDataResponse(directChatService.findAllByPage(ch_id,page,size));
    }

    @PostMapping("/file")
    public void sendFile(@RequestParam("image") MultipartFile multipartFile,
                         @RequestParam("user_id") Long userId,
                         @RequestParam("ch_id") Long id) throws IOException {
        String upload = s3Config.upload(multipartFile);

        DirectChat directChat = DirectChat.builder()
                .content(upload)
                .userId(userId)
                .channelId(id)
                .localDateTime(LocalDateTime.now()).build();

        DirectChat save = messageRepository.save(directChat);

        HashMap<String,String> msg = new HashMap<>();
        msg.put("id",save.getId());
        msg.put("message",upload);
        msg.put("time", String.valueOf(LocalDateTime.now()));

        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(msg);
        template.convertAndSend("/topic/direct/" + id, json);

    }
}
