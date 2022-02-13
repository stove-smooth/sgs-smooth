package com.example.chatserver.controller;

import com.example.chatserver.client.PresenceClient;
import com.example.chatserver.config.TcpClientGateway;
import com.example.chatserver.dto.request.SignalingRequest;
import com.example.chatserver.kafka.MessageSender;
import com.example.chatserver.domain.ChannelMessage;
import com.example.chatserver.dto.request.FileUploadRequest;
import com.example.chatserver.dto.request.LoginSessionRequest;
import com.example.chatserver.dto.response.*;
import com.example.chatserver.service.ChannelMessageService;
import com.example.chatserver.service.ResponseService;
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

    private final MessageSender messageSender;
    private final ChannelMessageService channelChatService;
    private final ResponseService responseService;
    private final TcpClientGateway tcpClientGateway;
    private final SimpMessagingTemplate template;

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
        String lastRoom = tcpClientGateway.send(loginSessionRequest.toString());
        channelChatService.setRoomTime(loginSessionRequest,lastRoom);
    }

    // 커뮤니티 입장 시 음성,영상 인원 보여주기
    @MessageMapping("/community-signaling")
    public void communitySignaling(@Payload LoginSessionRequest loginSessionRequest) {
        String send = tcpClientGateway.send(loginSessionRequest.toString());
        log.info("시그널링:" + send);
        log.info("컴아디:" + loginSessionRequest.getCommunity_id());
        template.convertAndSend("/topic/community/" + loginSessionRequest.getCommunity_id(), send);
    }

    // 시그널링 상태관리
    @MessageMapping("/signaling")
    public void sendSignalingState(@Payload LoginSessionRequest loginSessionRequest) {
        String send = tcpClientGateway.send(loginSessionRequest.toString());
        log.info("시그널링:" + send);
        template.convertAndSend("/topic/community/" + loginSessionRequest.getCommunity_id(), send);
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
        template.convertAndSend("/topic/community/" + signalingRequest.getCommunityId(), signalingRequest.toString());
    }

}
