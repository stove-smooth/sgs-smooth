package com.example.chatserver.controller;

import com.example.chatserver.client.PresenceClient;
import com.example.chatserver.config.TcpClientGateway;
import com.example.chatserver.dto.request.SignalingRequest;
import com.example.chatserver.dto.request.StateRequest;
import com.example.chatserver.kafka.MessageSender;
import com.example.chatserver.domain.ChannelMessage;
import com.example.chatserver.dto.request.FileUploadRequest;
import com.example.chatserver.dto.request.LoginSessionRequest;
import com.example.chatserver.dto.response.*;
import com.example.chatserver.service.ChannelMessageService;
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

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;

@Slf4j
@RestController
@RequestMapping(value = "chat-server")
@RequiredArgsConstructor
public class ChannelMessageController {

    @Value("${spring.kafka.consumer.direct-topic}")
    private String communityChatTopic;

    @Value("${spring.kafka.consumer.etc-community-topic}")
    private String etcCommunityTopic;

    @Value("${spring.kafka.consumer.file-topic}")
    private String fileTopic;

    @Value("${spring.kafka.consumer.state-topic}")
    private String stateTopic;

    private final MessageSender messageSender;
    private final ChannelMessageService channelChatService;
    private final ResponseService responseService;
    private final TcpClientGateway tcpClientGateway;

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

    // 방 이동 시 상태관리
    @MessageMapping("/join-channel")
    public void sendState(@Payload LoginSessionRequest loginSessionRequest) {
        log.info(loginSessionRequest.toString());
        String lastRoom = tcpClientGateway.send(loginSessionRequest.toString());
        String last = lastRoom.split(",")[0];
        String now = lastRoom.split(",")[1];
        channelChatService.setRoomTime(loginSessionRequest,last,now);
    }

    // 커뮤니티 입장 시 현재 음성,영상 인원 보여주기
    @MessageMapping("/community-signaling")
    public void communitySignaling(@Payload LoginSessionRequest loginSessionRequest) {
        String send = tcpClientGateway.send(loginSessionRequest.toString());
        StateRequest stateRequest = StateRequest.builder()
                .type("before-enter")
                .state(send)
                .communityId(loginSessionRequest.getCommunity_id()).build();
        messageSender.signaling(stateTopic,stateRequest);
    }

    // 음성,영상 채팅방 입장 시 현재 인원 갱신
    @MessageMapping("/signaling")
    public void sendSignalingState(@Payload LoginSessionRequest loginSessionRequest) {
        String send = tcpClientGateway.send(loginSessionRequest.toString());
        StateRequest stateRequest = StateRequest.builder()
                .type("enter")
                .state(send)
                .communityId(loginSessionRequest.getCommunity_id()).build();
        messageSender.signaling(stateTopic,stateRequest);
    }

    @GetMapping("/community")
    public DataResponse<List<MessageResponse>> community(@RequestParam(value = "ch_id") Long ch_id,
                                                         @RequestParam(defaultValue = "0") int page,
                                                         @RequestParam(defaultValue = "50") int size) {

        return responseService.getDataResponse(channelChatService.findAllByPage(ch_id,page,size));
    }

    @PostMapping("/channel/file")
    public CommonResponse sendFile(@ModelAttribute FileUploadRequest fileUploadRequest) throws IOException {
        FileUploadResponse uploadResponse = channelChatService.fileUpload(fileUploadRequest);
        messageSender.fileUpload(fileTopic,uploadResponse);

        return responseService.getSuccessResponse();

    }

    @PutMapping("/community-user-list/{community_id}")
    public CommonResponse findUserList(@PathVariable(value = "community_id") Long community_id,
                                       @RequestBody List<Long> ids) {
        channelChatService.findUserList(community_id,ids);

        return responseService.getSuccessResponse();
    }

    @PostMapping("/signaling-list-community")
    public void getSignalingListForCommunity(@RequestBody SignalingRequest signalingRequest) {
        StateRequest stateRequest = StateRequest.builder()
                .type("exit-community")
                .typeForExit(signalingRequest.getType())
                .channelId(signalingRequest.getChannelId())
                .ids(signalingRequest.getIds())
                .communityId(signalingRequest.getCommunityId()).build();
        messageSender.signaling(stateTopic,stateRequest);
    }
}
