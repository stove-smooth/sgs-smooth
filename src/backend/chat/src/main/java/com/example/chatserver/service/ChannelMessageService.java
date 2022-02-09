package com.example.chatserver.service;

import com.example.chatserver.client.CommunityClient;
import com.example.chatserver.client.UserClient;
import com.example.chatserver.config.S3Config;
import com.example.chatserver.domain.ChannelMessage;
import com.example.chatserver.domain.MessageTime;
import com.example.chatserver.dto.request.FileUploadRequest;
import com.example.chatserver.dto.request.LoginSessionRequest;
import com.example.chatserver.dto.response.*;
import com.example.chatserver.repository.ChannelMessageRepository;
import com.example.chatserver.repository.MessageTimeRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.TimeUnit;

@Slf4j
@Service
@RequiredArgsConstructor
public class ChannelMessageService {

    private final ChannelMessageRepository channelChatRepository;
    private final CommunityClient communityClient;
    private final RedisTemplate<String, CommunityFeignResponse.UserIdResponse> redisTemplateForIds;
    private final UserClient userClient;
    private final S3Config s3Config;
    private final MessageTimeRepository messageTimeRepository;
    // 2주
    private long TIME = 14 * 24 * 60 * 60 * 1000L;

    public List<MessageResponse> findAllByPage(Long ch_id, int page, int size) {
        Pageable paging = PageRequest.of(page,size, Sort.by("localDateTime").descending());
        Page<ChannelMessage> result = channelChatRepository.findByChannelId(ch_id,paging);
        List<Long> temp = new ArrayList<>();
        result.forEach((i) -> {
            temp.add(i.getUserId());
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
                    parentName = userInfoList.getResult().get(i.getUserId()).getName();
                    parentContent = parent.getContent();
                }
            }
            String name = userInfoList.getResult().get(i.getUserId()).getName();
            String image = userInfoList.getResult().get(i.getUserId()).getImage();
            MessageResponse channelMessageResponse = MessageResponse.builder()
                    .id(i.getId())
                    .name(name)
                    .profileImage(image)
                    .userId(i.getUserId())
                    .message(i.getContent())
                    .thumbnail(i.getThumbnail())
                    .fileType(i.getType())
                    .parentName(parentName)
                    .parentContent(parentContent)
                    .time(i.getLocalDateTime()).build();

            reads.add(channelMessageResponse);
        });
        Collections.reverse(reads);
        return reads;
    }

    public FileUploadResponse fileUpload(FileUploadRequest fileUploadRequest) throws IOException {
        if (fileUploadRequest.getFileType().equals("image") || fileUploadRequest.getFileType().equals("video")) {
            String image = null;
            String thumbnail = null;
            if (fileUploadRequest.getImage() != null) {
                image = s3Config.upload(fileUploadRequest.getImage());
                thumbnail = s3Config.upload(fileUploadRequest.getThumbnail());
            }

            ChannelMessage channelMessage = ChannelMessage.builder()
                    .content(image)
                    .thumbnail(thumbnail)
                    .userId(fileUploadRequest.getUserId())
                    .communityId(fileUploadRequest.getCommunityId())
                    .channelId(fileUploadRequest.getChannelId())
                    .type(fileUploadRequest.getFileType())
                    .localDateTime(LocalDateTime.now()).build();

            ChannelMessage save = channelChatRepository.save(channelMessage);

            FileUploadResponse uploadResponse = FileUploadResponse.builder()
                    .id(save.getId())
                    .userId(save.getUserId())
                    .name(fileUploadRequest.getName())
                    .profileImage(fileUploadRequest.getProfileImage())
                    .message(image)
                    .channelId(fileUploadRequest.getChannelId())
                    .thumbnail(thumbnail)
                    .type(fileUploadRequest.getType())
                    .fileType(fileUploadRequest.getFileType())
                    .time(LocalDateTime.now()).build();
            return uploadResponse;
        } else {
            String image = null;
            if (fileUploadRequest.getImage() != null) {
                image = s3Config.upload(fileUploadRequest.getImage());;
            }

            ChannelMessage channelMessage = ChannelMessage.builder()
                    .content(image)
                    .userId(fileUploadRequest.getUserId())
                    .communityId(fileUploadRequest.getCommunityId())
                    .channelId(fileUploadRequest.getChannelId())
                    .type(fileUploadRequest.getFileType())
                    .localDateTime(LocalDateTime.now()).build();

            ChannelMessage save = channelChatRepository.save(channelMessage);

            FileUploadResponse uploadResponse = FileUploadResponse.builder()
                    .id(save.getId())
                    .userId(save.getUserId())
                    .name(fileUploadRequest.getName())
                    .profileImage(fileUploadRequest.getProfileImage())
                    .message(image)
                    .channelId(save.getChannelId())
                    .type(fileUploadRequest.getType())
                    .fileType(fileUploadRequest.getFileType())
                    .time(LocalDateTime.now()).build();

            return uploadResponse;
        }
    }

    public void findUserList(Long community_id, List<Long> ids) {
        Object Channel_key = redisTemplateForIds.opsForValue().get("CH" + community_id);
        if (Channel_key == null) {
            // 커뮤니티에 속해 있는 유저 id값 반환
            CommunityFeignResponse userIds = communityClient.getUserIds(community_id);
            redisTemplateForIds.opsForValue().set("CH"+ community_id,userIds.getResult(),TIME, TimeUnit.MILLISECONDS);
        } else {
            CommunityFeignResponse.UserIdResponse userIdResponse = new CommunityFeignResponse.UserIdResponse();
            userIdResponse.setMembers(ids);
            redisTemplateForIds.opsForValue().set("CH" + community_id, userIdResponse, TIME, TimeUnit.MILLISECONDS);
        }
    }

    public void setRoomTime(LoginSessionRequest loginSessionRequest, String lastRoom) {
        MessageTime result = messageTimeRepository.findByChannelId(lastRoom);
        if (result == null) {
            Map<String,LocalDateTime> users = new HashMap<>();
            users.put(loginSessionRequest.getUser_id(), LocalDateTime.now());
            MessageTime messageTime = MessageTime.builder()
                    .channelId(lastRoom)
                    .read(users).build();
            messageTimeRepository.save(messageTime);
        } else {
            Map<String, LocalDateTime> read = result.getRead();
            read.put(loginSessionRequest.getUser_id(),LocalDateTime.now());
            result.setRead(read);
            messageTimeRepository.save(result);
        }
    }
}
