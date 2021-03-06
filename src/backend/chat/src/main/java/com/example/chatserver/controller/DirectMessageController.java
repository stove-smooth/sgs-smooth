package com.example.chatserver.controller;

import com.example.chatserver.dto.request.SignalingRequest;
import com.example.chatserver.dto.request.StateRequest;
import com.example.chatserver.kafka.MessageSender;
import com.example.chatserver.domain.DirectMessage;
import com.example.chatserver.dto.request.FileUploadRequest;
import com.example.chatserver.dto.request.MessageCountRequest;
import com.example.chatserver.dto.response.*;
import com.example.chatserver.service.DirectMessageService;
import com.example.chatserver.service.ResponseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;


@Slf4j
@RestController
@RequestMapping(value = "chat-server")
@RequiredArgsConstructor
public class DirectMessageController {

    @Value("${spring.kafka.consumer.chat-topic}")
    private String directChatTopic;

    @Value("${spring.kafka.consumer.etc-direct-topic}")
    private String etcDirectTopic;

    @Value("${spring.kafka.consumer.file-topic}")
    private String fileTopic;

    @Value("${spring.kafka.consumer.state-topic}")
    private String stateTopic;

    private final MessageSender messageSender;
    private final DirectMessageService directChatService;
    private final ResponseService responseService;

    @MessageMapping("/send-direct-typing")
    public void sendTyping(@Payload DirectMessage directChat) {
        messageSender.sendToEtcDirectChat(etcDirectTopic,directChat);
    }

    @MessageMapping("/send-direct-message")
    public void sendMessage(@Payload DirectMessage directChat) {
        directChat.setLocalDateTime(LocalDateTime.now());
        messageSender.sendToDirectChat(directChatTopic,directChat);
    }
    @MessageMapping("/send-direct-reply")
    public void sendReplyMessage(@Payload DirectMessage directChat) {
        messageSender.sendToEtcDirectChat(etcDirectTopic,directChat);
    }
    @MessageMapping("/send-direct-modify")
    public void sendDirectMessage(@Payload DirectMessage directChat) {
        messageSender.sendToEtcDirectChat(etcDirectTopic,directChat);
    }
    @MessageMapping("/send-direct-delete")
    public void sendDeleteMessage(@Payload DirectMessage directChat) {
        messageSender.sendToEtcDirectChat(etcDirectTopic,directChat);
    }

    @GetMapping("/direct")
    public DataResponse<List<MessageResponse>> community(@RequestParam(value = "ch_id") Long ch_id,
                                                         @RequestParam(defaultValue = "0") int page,
                                                         @RequestParam(defaultValue = "50") int size) {

        return responseService.getDataResponse(directChatService.findAllByPage(ch_id,page,size));
    }

    // todo kafka
    @PostMapping("/file")
    public CommonResponse sendFile(@ModelAttribute FileUploadRequest fileUploadRequest) throws IOException {
        FileUploadResponse msg = directChatService.fileUpload(fileUploadRequest);
        messageSender.fileUpload(fileTopic,msg);

        return responseService.getSuccessResponse();
    }

    @PutMapping("/room-user-list/{room_id}")
    public CommonResponse findUserList(@PathVariable(value = "room_id") Long room_id,
                                       @RequestBody List<Long> ids) {
        directChatService.findUserList(room_id,ids);

        return responseService.getSuccessResponse();
    }

    @PostMapping("/message-count")
    public List<MessageCountResponse> messageCount(@RequestBody MessageCountRequest messageCountRequest) {
        return directChatService.messageCount(messageCountRequest);
    }

    @PostMapping("/signaling-list-direct")
    public void getSignalingListForDirect(@RequestBody SignalingRequest signalingRequest) {
        StateRequest stateRequest = StateRequest.builder()
                .type("exit-community")
                .typeForExit(signalingRequest.getType())
                .channelId(signalingRequest.getChannelId())
                .ids(signalingRequest.getIds()).build();
        messageSender.signaling(stateTopic, stateRequest);
    }
}
