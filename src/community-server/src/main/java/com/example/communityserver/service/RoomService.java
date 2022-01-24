package com.example.communityserver.service;

import com.example.communityserver.client.UserClient;
import com.example.communityserver.domain.Room;
import com.example.communityserver.domain.RoomMember;
import com.example.communityserver.domain.type.CommonStatus;
import com.example.communityserver.dto.response.RoomListResponse;
import com.example.communityserver.dto.response.RoomResponse;
import com.example.communityserver.dto.response.UserInfoListFeignResponse;
import com.example.communityserver.dto.response.UserResponse;
import com.example.communityserver.exception.CustomException;
import com.example.communityserver.repository.RoomMemberRepository;
import com.example.communityserver.repository.RoomRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

import static com.example.communityserver.exception.CustomExceptionStatus.EMPTY_USER_IN_ROOM;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class RoomService {

    private final RoomRepository repository;
    private final RoomMemberRepository roomMemberRepository;

    private final UserClient userClient;

    public RoomListResponse getRooms(Long userId, String token) {

        List<Room> rooms = roomMemberRepository.findByUserId(userId).stream()
                .filter(rm -> rm.getStatus().equals(CommonStatus.NORMAL))
                .map(RoomMember::getRoom)
                .collect(Collectors.toList());

        // auth service에 요청보낼 user id 리스트
        List<Long> ids = new ArrayList<>();
        rooms.forEach(room -> {
            // 1:1 메세지의 경우 상대방 user id 추출 후 리스트에 추가
            if (!room.getIsGroup()) {
                Long otherUserId = getOtherAccountIdInRoom(room, userId);
                ids.add(otherUserId);
            }
        });

        // 유저 정보 요청
        HashMap<Long, UserResponse> userMap = getUserMap(ids, token);

        List<RoomResponse> roomResponses = rooms.stream()
                .map(room -> RoomResponse.fromEntity(room))
                .collect(Collectors.toList());
        
        // 1:1 메시지방 유저 정보로 업데이트
        roomResponses.forEach(roomResponse -> {
            updateUserInfo(roomResponse, userMap);
        });

        // TODO 메세지 순으로 정렬

        return new RoomListResponse(roomResponses);
    }

    private Long getOtherAccountIdInRoom(Room room, Long userId) {
        return room.getMembers().stream()
                .filter(rm -> !rm.getUserId().equals(userId))
                .findAny().orElseThrow(() -> new CustomException(EMPTY_USER_IN_ROOM))
                .getUserId();
    }

    private HashMap<Long, UserResponse> getUserMap(List<Long> ids, String token) {
        // 중복 id 제거
        Set<Long> set = new HashSet<>(ids);
        ids = new ArrayList<>(set);
        // Todo auth 터졌을 때 예외 처리
        UserInfoListFeignResponse response = userClient.getUserInfoList(token, ids);
        return response.getResult();
    }

    private void updateUserInfo(RoomResponse roomResponse, HashMap<Long, UserResponse> userMap) {
        if (!roomResponse.isGroup()) {
            UserResponse otherUser = userMap.get(roomResponse.getMembers().get(0));
            if (!Objects.isNull(otherUser)) {
                roomResponse.setIcon(otherUser.getImage());
                roomResponse.setState(otherUser.getState());
            }
        }
    }
}
