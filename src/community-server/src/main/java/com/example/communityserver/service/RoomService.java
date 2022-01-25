package com.example.communityserver.service;

import com.example.communityserver.client.UserClient;
import com.example.communityserver.domain.Room;
import com.example.communityserver.domain.RoomInvitation;
import com.example.communityserver.domain.RoomMember;
import com.example.communityserver.domain.type.CommonStatus;
import com.example.communityserver.dto.request.CreateInvitationRequest;
import com.example.communityserver.dto.request.CreateRoomRequest;
import com.example.communityserver.dto.request.EditIconRequest;
import com.example.communityserver.dto.request.EditNameRequest;
import com.example.communityserver.dto.response.*;
import com.example.communityserver.exception.CustomException;
import com.example.communityserver.repository.RoomInvitationRepository;
import com.example.communityserver.repository.RoomMemberRepository;
import com.example.communityserver.repository.RoomRepository;
import com.example.communityserver.util.AmazonS3Connector;
import com.example.communityserver.util.Base62;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

import static com.example.communityserver.exception.CustomExceptionStatus.*;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class RoomService {

    @Value("${smooth.url}")
    private String HOST_ADDRESS;
    private String ROOM_INVITATION_PREFIX = "/r/";

    private final RoomRepository roomRepository;
    private final RoomMemberRepository roomMemberRepository;
    private final RoomInvitationRepository roomInvitationRepository;

    private final AmazonS3Connector amazonS3Connector;
    private final Base62 base62;

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
            updateUserInfo(roomResponse, userMap, userId);
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

    private void updateUserInfo(RoomResponse roomResponse, HashMap<Long, UserResponse> userMap, Long userId) {
        if (!roomResponse.isGroup()) {
            UserResponse otherUser = userMap.get(
                    roomResponse.getMembers().stream()
                            .filter(rm -> !rm.equals(userId))
                            .findFirst().get());
            if (!Objects.isNull(otherUser)) {
                roomResponse.setName(otherUser.getName());
                roomResponse.setIcon(otherUser.getImage());
                roomResponse.setState(otherUser.getState());
            }
        }
    }

    private void updateUserInfo(RoomDetailResponse roomDetailResponse, HashMap<Long, UserResponse> userMap, Long userId) {
        if (!roomDetailResponse.isGroup()) {
            UserResponse otherUser = userMap.get(
                    roomDetailResponse.getMembers().stream()
                            .filter(rm -> !rm.getId().equals(userId))
                            .map(RoomMemberResponse::getId)
                            .findFirst().get());
            if (!Objects.isNull(otherUser)) {
                roomDetailResponse.setName(otherUser.getName());
            }
        }
    }

    @Transactional
    public RoomDetailResponse createRoom(Long userId, CreateRoomRequest request, String token) {

        List<RoomMember> members = new ArrayList<>();

        // 유저 정보 요청
        List<Long> ids = request.getMembers();
        ids.add(userId);
        HashMap<Long, UserResponse> userMap = getUserMap(ids, token);

        // TODO string 계속 더하는 건 좋지 않으니 stringbuilder로 가져가는 것도 고민하기
        String name = "";
        for (int i=0; i<ids.size(); i++) {
            Long id = ids.get(i);
            boolean isOwner = id.equals(userId) ? true : false;
            String otherUsername = userMap.get(id).getName();
            members.add(RoomMember.createRoomMember(id, isOwner));
            name += otherUsername;
            if (i != ids.size()-1)
                name += ", ";
        }

        Room newRoom = Room.createRoom(name, members);
        roomRepository.save(newRoom);

        RoomDetailResponse roomDetailResponse = RoomDetailResponse.fromEntity(newRoom);
        roomDetailResponse.setMembers(newRoom.getMembers().stream()
            .map(rm -> RoomMemberResponse.fromEntity(rm, userMap))
            .collect(Collectors.toList()));
        updateUserInfo(roomDetailResponse, userMap, userId);

        return roomDetailResponse;
    }

    public RoomDetailResponse getRoom(Long userId, Long roomId, String token) {
        Room room = roomRepository.findById(roomId)
                .filter(r -> r.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_ROOM));

        isContain(room, userId);

        List<Long> ids = room.getMembers().stream()
                .filter(rm -> rm.getStatus().equals(CommonStatus.NORMAL))
                .map(RoomMember::getUserId)
                .collect(Collectors.toList());
        HashMap<Long, UserResponse> userMap = getUserMap(ids, token);

        RoomDetailResponse roomDetailResponse = RoomDetailResponse.fromEntity(room);
        roomDetailResponse.setMembers(room.getMembers().stream()
                .map(rm -> RoomMemberResponse.fromEntity(rm, userMap))
                .collect(Collectors.toList()));
        updateUserInfo(roomDetailResponse, userMap, userId);

        return roomDetailResponse;
    }

    private void isContain(Room room, Long userId) {
        boolean isContain = room.getMembers().stream()
                .filter(rm -> rm.getStatus().equals(CommonStatus.NORMAL))
                .map(RoomMember::getUserId)
                .collect(Collectors.toList())
                .contains(userId);

        if (!isContain)
            throw new CustomException(NON_AUTHORIZATION);
    }

    @Transactional
    public void editName(Long userId, EditNameRequest request) {
        Room room = roomRepository.findById(request.getId())
                .filter(r -> r.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_ROOM));

        if (!room.getIsGroup())
            throw new CustomException(CANT_EXCHANGE_PERSONAL_ROOM);

        isContain(room, userId);

        room.setName(request.getName());
    }

    @Transactional
    public void editIcon(Long userId, EditIconRequest request) {
        Room room = roomRepository.findById(request.getId())
                .filter(r -> r.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_ROOM));

        if (!room.getIsGroup())
            throw new CustomException(CANT_EXCHANGE_PERSONAL_ROOM);

        isContain(room, userId);

        String iconImage = null;
        if (!Objects.isNull(request.getIcon()))
            iconImage = amazonS3Connector.uploadImage(userId, request.getIcon());

        room.setIconImage(iconImage);
    }

    @Transactional
    public CreateInvitationResponse createInvitation(Long userId, CreateInvitationRequest request) {
        Room room = roomRepository.findById(request.getId())
                .filter(r -> r.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_ROOM));

        isContain(room, userId);

        // 이미 생성한 초대장 있는지 확인
        LocalDateTime now = LocalDateTime.now();
        RoomInvitation roomInvitation = room.getInvitations().stream()
                .filter(i -> i.getExpiredAt().isAfter(now))
                .findAny().orElse(null);

        // 없는 경우 생성
        if (Objects.isNull(roomInvitation)) {
            RoomInvitation newInvitation = new RoomInvitation();
            newInvitation.setRoom(room);
            newInvitation.setExpiredAt(now.plusDays(1L));
            roomInvitation = roomInvitationRepository.save(newInvitation);
            roomInvitation.setCode(base62.encode(roomInvitation.getId()));
        }

        return new CreateInvitationResponse(HOST_ADDRESS + ROOM_INVITATION_PREFIX + roomInvitation.getCode());
    }
}
