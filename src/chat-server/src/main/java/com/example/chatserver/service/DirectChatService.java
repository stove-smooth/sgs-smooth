package com.example.chatserver.service;

import com.example.chatserver.client.UserClient;
import com.example.chatserver.domain.ChannelMessage;
import com.example.chatserver.domain.DirectChat;
import com.example.chatserver.dto.response.MessageResponse;
import com.example.chatserver.dto.response.UserInfoListFeignResponse;
import com.example.chatserver.exception.CustomException;
import com.example.chatserver.exception.CustomExceptionStatus;
import com.example.chatserver.repository.DirectChatRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class DirectChatService {

    private final DirectChatRepository directChatRepository;
    private final UserClient userClient;

    public HashMap<String,String> modifyMessage(DirectChat directChat) {
        DirectChat result = directChatRepository.findById(directChat.getId())
                .orElseThrow(() -> new CustomException(CustomExceptionStatus.MESSAGE_NOT_FOUND));

        result.setContent(directChat.getContent());
        directChatRepository.save(result);

        HashMap<String,String> msg = new HashMap<>();
        msg.put("id",result.getId());
        msg.put("userId", String.valueOf(result.getUserId()));
        msg.put("message",result.getContent());
        msg.put("time", String.valueOf(result.getLocalDateTime()));

        return msg;
    }

    public HashMap<String, String> deleteMessage(DirectChat directChat) {
        DirectChat result = directChatRepository.findById(directChat.getId())
                .orElseThrow(() -> new CustomException(CustomExceptionStatus.MESSAGE_NOT_FOUND));

        if (!result.getUserId().equals(directChat.getUserId())) {
            throw new CustomException(CustomExceptionStatus.ACCOUNT_NOT_VALID);
        }

        directChatRepository.deleteById(result.getId());

        HashMap<String,String> msg = new HashMap<>();
        msg.put("id",result.getId());
        msg.put("delete", "yes");
        return msg;
    }

    public List<MessageResponse> findAllByPage(Long ch_id, int page, int size) {
        Pageable paging = PageRequest.of(page,size, Sort.by("localDateTime").descending());
        Page<DirectChat> result = directChatRepository.findByChannelId(ch_id,paging);
        List<Long> temp = new ArrayList<>();
        result.forEach((i) -> {
            temp.add(i.getUserId());
        });
        Set<Long> convert = new HashSet<>(temp);
        List<Long> ids = new ArrayList<>(convert);
        UserInfoListFeignResponse userInfoList = userClient.getUserInfoList(ids);
        List<MessageResponse> reads = new ArrayList<>();
        result.forEach((i) -> {
            String name = userInfoList.getResult().get(i.getUserId()).getName();
            String image = userInfoList.getResult().get(i.getUserId()).getImage();
            MessageResponse directMessageResponse = MessageResponse.builder()
                    .id(i.getId())
                    .name(name)
                    .profileImage(image)
                    .userId(i.getUserId())
                    .message(i.getContent())
                    .time(i.getLocalDateTime()).build();

            reads.add(directMessageResponse);
        });
        Collections.reverse(reads);
        return reads;
    }
}
