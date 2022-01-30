package com.example.chatserver.service;

import com.example.chatserver.client.UserClient;
import com.example.chatserver.domain.ChannelMessage;
import com.example.chatserver.dto.response.MessageResponse;
import com.example.chatserver.dto.response.UserInfoFeignResponse;
import com.example.chatserver.dto.response.UserInfoListFeignResponse;
import com.example.chatserver.exception.CustomException;
import com.example.chatserver.exception.CustomExceptionStatus;
import com.example.chatserver.repository.ChannelMessageRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.bson.types.ObjectId;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class ChannelChatService {

    private final ChannelMessageRepository channelChatRepository;
    private final UserClient userClient;

    public List<MessageResponse> findAllByPage(Long ch_id, int page, int size) {
        Pageable paging = PageRequest.of(page,size, Sort.by("localDateTime").descending());
        Page<ChannelMessage> result = channelChatRepository.findByChannelId(ch_id,paging);
        List<Long> temp = new ArrayList<>();
        result.forEach((i) -> {
            temp.add(i.getAccountId());
        });
        Set<Long> convert = new HashSet<>(temp);
        List<Long> ids = new ArrayList<>(convert);
        UserInfoListFeignResponse userInfoList = userClient.getUserInfoList(ids);
        List<MessageResponse> reads = new ArrayList<>();
        result.forEach((i) -> {
            String name = userInfoList.getResult().get(i.getAccountId()).getName();
            String image = userInfoList.getResult().get(i.getAccountId()).getImage();
            MessageResponse channelMessageResponse = MessageResponse.builder()
                    .id(i.getId())
                    .name(name)
                    .profileImage(image)
                    .userId(i.getAccountId())
                    .message(i.getContent())
                    .time(i.getLocalDateTime()).build();

            reads.add(channelMessageResponse);
        });
        Collections.reverse(reads);
        return reads;
    }

    public HashMap<String,String> modifyMessage(ChannelMessage channelMessage) {
        ChannelMessage result = channelChatRepository.findById(channelMessage.getId())
                .orElseThrow(() -> new CustomException(CustomExceptionStatus.MESSAGE_NOT_FOUND));

        result.setContent(channelMessage.getContent());
        channelChatRepository.save(result);

        HashMap<String,String> msg = new HashMap<>();
        msg.put("id",result.getId());
        msg.put("userId", String.valueOf(result.getAccountId()));
        msg.put("message",result.getContent());
        msg.put("time", String.valueOf(result.getLocalDateTime()));

        return msg;
    }

    public HashMap<String, String> deleteMessage(ChannelMessage channelMessage) {
        ChannelMessage result = channelChatRepository.findById(channelMessage.getId())
                .orElseThrow(() -> new CustomException(CustomExceptionStatus.MESSAGE_NOT_FOUND));

        if (!result.getAccountId().equals(channelMessage.getAccountId())) {
            throw new CustomException(CustomExceptionStatus.ACCOUNT_NOT_VALID);
        }

        channelChatRepository.deleteById(channelMessage.getId());

        HashMap<String,String> msg = new HashMap<>();
        msg.put("id",result.getId());
        msg.put("delete", "yes");
        return msg;
    }

    public HashMap<String, String> replyMessage(ChannelMessage channelMessage) {

        UserInfoFeignResponse userInfo = userClient.getUserInfo(channelMessage.getAccountId());

        ChannelMessage save = ChannelMessage.builder()
                .channelId(channelMessage.getChannelId())
                .accountId(channelMessage.getAccountId())
                .content(channelMessage.getContent())
                .parentId(channelMessage.getParentId())
                .localDateTime(LocalDateTime.now()).build();
        ChannelMessage result = channelChatRepository.save(save);

        HashMap<String,String> msg = new HashMap<>();
        msg.put("id",result.getId());
        msg.put("userId", String.valueOf(result.getAccountId()));
        msg.put("name",userInfo.getResult().getName());
        msg.put("profileImage",userInfo.getResult().getProfileImage());
        msg.put("message",result.getContent());
        msg.put("time", String.valueOf(result.getLocalDateTime()));

        return msg;
    }
}
