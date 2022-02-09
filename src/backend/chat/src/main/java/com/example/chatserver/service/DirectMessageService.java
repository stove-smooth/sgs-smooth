package com.example.chatserver.service;

import com.example.chatserver.client.CommunityClient;
import com.example.chatserver.client.UserClient;
import com.example.chatserver.config.S3Config;
import com.example.chatserver.domain.DirectMessage;
import com.example.chatserver.dto.request.FileUploadRequest;
import com.example.chatserver.dto.response.*;
import com.example.chatserver.repository.DirectMessageRepository;
import lombok.RequiredArgsConstructor;
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

@Service
@RequiredArgsConstructor
public class DirectMessageService {

    private final DirectMessageRepository directChatRepository;
    private final UserClient userClient;
    private final S3Config s3Config;
    private final CommunityClient communityClient;
    private final RedisTemplate<String, CommunityFeignResponse.UserIdResponse> redisTemplateForIds;
    // 2주
    private long TIME = 14 * 24 * 60 * 60 * 1000L;

    public List<MessageResponse> findAllByPage(Long ch_id, int page, int size) {
        Pageable paging = PageRequest.of(page,size, Sort.by("localDateTime").descending());
        Page<DirectMessage> result = directChatRepository.findByChannelId(ch_id,paging);
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
                DirectMessage parent = directChatRepository.findById(i.getParentId()).orElse(null);
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
            MessageResponse directMessageResponse = MessageResponse.builder()
                    .id(i.getId())
                    .name(name)
                    .profileImage(image)
                    .userId(i.getUserId())
                    .message(i.getContent())
                    .messageType(i.getType())
                    .parentName(parentName)
                    .parentContent(parentContent)
                    .time(i.getLocalDateTime()).build();

            reads.add(directMessageResponse);
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

        DirectMessage directChat = DirectMessage.builder()
                .content(image)
                .thumbnail(thumbnail)
                .userId(fileUploadRequest.getUserId())
                .channelId(fileUploadRequest.getChannelId())
                .type(fileUploadRequest.getFileType())
                .localDateTime(LocalDateTime.now()).build();

        UserInfoFeignResponse userInfo = userClient.getUserInfo(fileUploadRequest.getUserId());

        DirectMessage save = directChatRepository.save(directChat);

        FileUploadResponse uploadResponse = FileUploadResponse.builder()
                .id(save.getId())
                .name(userInfo.getResult().getName())
                .profileImage(userInfo.getResult().getProfileImage())
                .message(image)
                .thumbnail(thumbnail)
                .type(fileUploadRequest.getType())
                .fileType(fileUploadRequest.getFileType())
                .channelId(fileUploadRequest.getChannelId())
                .time(LocalDateTime.now()).build();

        return uploadResponse;
    }

    public void findUserList(Long room_id, List<Long> ids) {
        Object Room_key = redisTemplateForIds.opsForValue().get("DM" + room_id);
        if (Room_key == null) {
            // 커뮤니티에 속해 있는 유저 id값 반환
            CommunityFeignResponse userIds = communityClient.getUserIdsFromDM(room_id);
            redisTemplateForIds.opsForValue().set("DM"+ room_id,userIds.getResult(),TIME, TimeUnit.MILLISECONDS);
        } else {
            CommunityFeignResponse.UserIdResponse userIdResponse = new CommunityFeignResponse.UserIdResponse();
            userIdResponse.setMembers(ids);
            redisTemplateForIds.opsForValue().set("DM" + room_id, userIdResponse, TIME, TimeUnit.MILLISECONDS);
        }
    }
}
