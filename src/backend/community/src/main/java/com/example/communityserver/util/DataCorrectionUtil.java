package com.example.communityserver.util;

import com.example.communityserver.client.ChatClient;
import com.example.communityserver.domain.Community;
import com.example.communityserver.domain.CommunityMember;
import com.example.communityserver.domain.Room;
import com.example.communityserver.domain.RoomMember;
import com.example.communityserver.domain.type.CommonStatus;
import com.example.communityserver.domain.type.CommunityMemberStatus;
import com.example.communityserver.exception.CustomException;
import com.example.communityserver.repository.CommunityRepository;
import com.example.communityserver.repository.RoomRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

import static com.example.communityserver.exception.CustomExceptionStatus.NON_VALID_COMMUNITY;
import static com.example.communityserver.exception.CustomExceptionStatus.NON_VALID_ROOM;

@Component
@RequiredArgsConstructor
public class DataCorrectionUtil {

    /**
     * 커뮤니티 서버 내에서 커뮤니티, 채널, 채팅방에서
     * 소속된 사용자의 수에 변화(초대, 추방 등의 인원 변동)가 있는 경우
     * 채팅서버에 변동된 값을 전달하기 위한 유틸리티
     */

    private final ChatClient chatClient;
    private final CommunityRepository communityRepository;
    private final RoomRepository roomRepository;

    @Async
    @Transactional
    public void updateCommunityMember(Long communityId) {

        Community community = communityRepository.findById(communityId)
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_COMMUNITY));

        List<Long> ids = community.getMembers().stream()
                .filter(m -> m.getStatus().equals(CommunityMemberStatus.NORMAL))
                .map(CommunityMember::getUserId)
                .collect(Collectors.toList());

        chatClient.updateCommunityMember(communityId, ids);
    }

    @Async
    @Transactional
    public void updateRoomMember(Long roomId) {

        Room room = roomRepository.findById(roomId)
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_ROOM));

        List<Long> ids = room.getMembers().stream()
                .filter(m -> m.getStatus().equals(CommonStatus.NORMAL))
                .map(RoomMember::getUserId)
                .collect(Collectors.toList());

        chatClient.updateRoomMember(roomId, ids);
    }
}
