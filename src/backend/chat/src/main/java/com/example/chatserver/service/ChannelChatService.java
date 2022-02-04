package com.example.chatserver.service;

import com.example.chatserver.client.UserClient;
import com.example.chatserver.config.S3Config;
import com.example.chatserver.domain.ChannelMessage;
import com.example.chatserver.dto.request.FileUploadRequest;
import com.example.chatserver.dto.response.FileUploadResponse;
import com.example.chatserver.dto.response.MessageResponse;
import com.example.chatserver.dto.response.UserInfoFeignResponse;
import com.example.chatserver.dto.response.UserInfoListFeignResponse;
import com.example.chatserver.repository.ChannelMessageRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class ChannelChatService {

    private final ChannelMessageRepository channelChatRepository;
    private final UserClient userClient;
    private final S3Config s3Config;

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
            String parentName = null;
            String parentContent= null;
            if (i.getParentId() != null) {
                // todo 쿼리 리팩토링 해야 됨
                ChannelMessage parent = channelChatRepository.findById(i.getParentId()).orElse(null);
                if (parent == null) {
                    parentName = "";
                    parentContent = "삭제된 메세지입니다.";
                } else {
                    parentName = userInfoList.getResult().get(i.getAccountId()).getName();
                    parentContent = parent.getContent();
                }
            }
            String name = userInfoList.getResult().get(i.getAccountId()).getName();
            String image = userInfoList.getResult().get(i.getAccountId()).getImage();
            MessageResponse channelMessageResponse = MessageResponse.builder()
                    .id(i.getId())
                    .name(name)
                    .profileImage(image)
                    .userId(i.getAccountId())
                    .message(i.getContent())
                    .parentName(parentName)
                    .parentContent(parentContent)
                    .time(i.getLocalDateTime()).build();

            reads.add(channelMessageResponse);
        });
        Collections.reverse(reads);
        return reads;
    }

    public FileUploadResponse fileUpload(FileUploadRequest fileUploadRequest) throws IOException {
        String image = null;
        String thumbnail = null;
        if (fileUploadRequest.getImage() != null) {
            image = s3Config.upload(fileUploadRequest.getImage());
            thumbnail = s3Config.upload(fileUploadRequest.getThumbnail());
        }

        ChannelMessage channelMessage = ChannelMessage.builder()
                .content(image)
                .thumbnail(thumbnail)
                .accountId(fileUploadRequest.getUserId())
                .channelId(fileUploadRequest.getChannelId())
                .localDateTime(LocalDateTime.now()).build();

        UserInfoFeignResponse userInfo = userClient.getUserInfo(fileUploadRequest.getUserId());

        ChannelMessage save = channelChatRepository.save(channelMessage);

        FileUploadResponse uploadResponse = FileUploadResponse.builder()
                .id(save.getId())
                .name(userInfo.getResult().getName())
                .profileImage(userInfo.getResult().getProfileImage())
                .message(image)
                .thumbnail(thumbnail)
                .type(fileUploadRequest.getType())
                .channelId(fileUploadRequest.getChannelId())
                .time(LocalDateTime.now()).build();

        return uploadResponse;

    }
}
