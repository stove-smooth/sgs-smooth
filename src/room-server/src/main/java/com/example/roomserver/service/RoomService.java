package com.example.roomserver.service;

import com.example.roomserver.client.AccountClient;
import com.example.roomserver.domain.Room;
import com.example.roomserver.domain.AccountRoom;
import com.example.roomserver.dto.response.AccountInfoResponse;
import com.example.roomserver.dto.response.RoomListResponse;
import com.example.roomserver.exception.CustomException;
import com.example.roomserver.repository.RoomRepository;
import com.example.roomserver.repository.AccountRoomRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;

import static com.example.roomserver.exception.CustomExceptionStatus.EMPTY_ACCOUNT_ID_IN_ROOM;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class RoomService {

    private final RoomRepository roomRepository;
    private final AccountRoomRepository accountRoomRepository;

    private final AccountClient accountClient;

    public RoomListResponse getRooms(Long accountId) {

        // accountId를 기준으로 방 리스트를 검색
        List<Room> rooms = accountRoomRepository.findByAccountId(accountId).stream()
                .map(AccountRoom::getRoom)
                .collect(Collectors.toList());

        // auth service에 요청보낼 account id 리스트
        List<Long> requestAccountIds = new ArrayList<>();

        rooms.forEach(room -> {
            if (!room.getIsGroup()) {
                // 상대방 id 추출
                Long otherAccountId = getOtherAccountIdInRoom(room, accountId);
                // 요청해야 할 id 리스트에 추가
                requestAccountIds.add(otherAccountId);
            }
        });

        // 한 번에 리스트 단위로 요청
        // AccountClient.getUserInfoMap(requestAccountIds);
        HashMap<Long, AccountInfoResponse> map = new HashMap<>();
        map.put(2L, new AccountInfoResponse("김", "김 프로필이미지", "online"));
        map.put(3L, new AccountInfoResponse("희", null, "online"));
        map.put(4L, new AccountInfoResponse("동", "동 프로필이미지", "online"));

        // 방 정보 반환
        List<RoomListResponse.RoomInfo> roomInfos = rooms.stream()
                .map(room -> RoomInfoFromEntity(room, map, accountId))
                .collect(Collectors.toList());

        return new RoomListResponse(roomInfos);
    }

    private Long getOtherAccountIdInRoom(Room room, Long myId) {
        return room.getAccounts().stream()
                .filter(accountRoom -> !myId.equals(accountRoom.getAccountId()))
                .findFirst().orElseThrow(() -> new CustomException(EMPTY_ACCOUNT_ID_IN_ROOM))
                .getAccountId();
    }

    private RoomListResponse.RoomInfo RoomInfoFromEntity(Room room, HashMap<Long, AccountInfoResponse> map, Long accountId) {
        RoomListResponse.RoomInfo roomInfo = RoomListResponse.RoomInfo.builder()
                .roomId(room.getId())
                .count(room.getAccounts().size())
                .isGroup(room.getIsGroup())
                .build();

        if (room.getIsGroup()) {
            // 그룹인 경우
            roomInfo.setAccountId(null);
            roomInfo.setTitle(room.getTitle());
            roomInfo.setIconImage(room.getIconImage());
            roomInfo.setState(null);
        } else {
            // 개인인 경우
            Long otherAccountId = getOtherAccountIdInRoom(room, accountId);
            AccountInfoResponse otherAccount = map.get(otherAccountId);

            roomInfo.setAccountId(otherAccountId);
            roomInfo.setTitle(otherAccount.getNickname());
            roomInfo.setIconImage(otherAccount.getProfileImage());
            roomInfo.setState(otherAccount.getState());
        }

        return roomInfo;
    }
}
