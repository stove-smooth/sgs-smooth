package com.example.chatserver.controller;

import com.example.chatserver.client.PresenceClient;
import com.example.chatserver.config.S3Config;
import com.example.chatserver.config.message.MessageSender;
import com.example.chatserver.domain.ChannelMessage;
import com.example.chatserver.dto.request.LoginSessionRequest;
import com.example.chatserver.dto.response.MessageResponse;
import com.example.chatserver.dto.response.DataResponse;
import com.example.chatserver.repository.ChannelMessageRepository;
import com.example.chatserver.service.ChannelChatService;
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
public class ChannelChatController {

    private final String topicName = "channel-server-topic";
    private final MessageSender messageSender;
    private final S3Config s3Config;
    private final ChannelChatService channelChatService;
    private final ChannelMessageRepository channelMessageRepository;
    private final ResponseService responseService;
    private final SimpMessagingTemplate template;
    private final PresenceClient presenceClient;


    @MessageMapping("/send-channel-message")
    public void sendMessage(@Payload ChannelMessage channelMessage) {
        channelMessage.setLocalDateTime(LocalDateTime.now());
        messageSender.send2(topicName, channelMessage);
    }

    @MessageMapping("/send-channel-reply")
    public void sendReplyMessage(@Payload ChannelMessage channelMessage) throws JsonProcessingException {
        HashMap<String, String> msg = channelChatService.replyMessage(channelMessage);
        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(msg);
        template.convertAndSend("/topic/group/" + channelMessage.getChannelId(), json);
    }

    @MessageMapping("/send-channel-modify")
    public void sendModifyMessage(@Payload ChannelMessage channelMessage) throws JsonProcessingException {
        HashMap<String, String> msg = channelChatService.modifyMessage(channelMessage);
        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(msg);
        template.convertAndSend("/topic/group/" + channelMessage.getChannelId(), json);
    }

    @MessageMapping("/send-channel-delete")
    public void sendDeleteMessage(@Payload ChannelMessage channelMessage) throws JsonProcessingException {
        HashMap<String, String> msg = channelChatService.deleteMessage(channelMessage);
        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(msg);
        template.convertAndSend("/topic/group/" + channelMessage.getChannelId(), json);
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
    @PostMapping("/channel/file")
    public void sendFile(@RequestParam("image") MultipartFile multipartFile,
                         @RequestParam("user_id") Long userId,
                         @RequestParam("ch_id") Long id) throws IOException {
        String upload = s3Config.upload(multipartFile);

        ChannelMessage channelMessage = ChannelMessage.builder()
                .content(upload)
                .accountId(userId)
                .channelId(id)
                .localDateTime(LocalDateTime.now()).build();

        ChannelMessage save = channelMessageRepository.save(channelMessage);

        HashMap<String,String> msg = new HashMap<>();
        msg.put("id",save.getId());
        msg.put("message",upload);
        msg.put("time", String.valueOf(LocalDateTime.now()));

        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(msg);
        template.convertAndSend("/topic/group/" + id, json);

    }
}
