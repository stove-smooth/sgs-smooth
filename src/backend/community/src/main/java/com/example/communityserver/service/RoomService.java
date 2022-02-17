package com.example.communityserver.service;

import com.example.communityserver.client.ChatClient;
import com.example.communityserver.client.UserClient;
import com.example.communityserver.domain.*;
import com.example.communityserver.domain.type.CommonStatus;
import com.example.communityserver.domain.type.CommunityMemberStatus;
import com.example.communityserver.domain.type.UserState;
import com.example.communityserver.dto.request.*;
import com.example.communityserver.dto.response.*;
import com.example.communityserver.exception.CustomException;
import com.example.communityserver.repository.RoomInvitationRepository;
import com.example.communityserver.repository.RoomMemberRepository;
import com.example.communityserver.repository.RoomRepository;
import com.example.communityserver.util.AmazonS3Connector;
import com.example.communityserver.util.Base62;
import com.example.communityserver.util.UserStateUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.SetOperations;
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

    private final RedisTemplate redisTemplate;
    private final AmazonS3Connector amazonS3Connector;
    private final Base62 base62;

    private final UserClient userClient;
    private final ChatClient chatClient;

    public RoomListResponse getRooms(Long userId, String token) {

        List<Room> rooms = roomMemberRepository.findByUserId(userId).stream()
                .filter(rm -> rm.getStatus().equals(CommonStatus.NORMAL))
                .map(RoomMember::getRoom)
                .collect(Collectors.toList());

        // 최신 메세지 순으로 정렬 요청하기
        List<Long> roomIds = rooms.stream().map(Room::getId).collect(Collectors.toList());
        List<MessageCountResponse> sortedRoomsWithCount = chatClient.getMyMessages(new MessageCountRequest(userId, roomIds));
        List<Long> sortedRoomIds = sortedRoomsWithCount.stream().map(e -> e.getRoomId()).collect(Collectors.toList());

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

        // 최신 메세지 순으로 DTO 생성
        HashMap<Long, Room> roomHashMap = new HashMap<>();
        for (Room room: rooms) {
            roomHashMap.put(room.getId(), room);
        }
        List<RoomResponse> roomResponses = new ArrayList<>();
        for (Long roomId: sortedRoomIds) {
            roomResponses.add(RoomResponse.fromEntity(roomHashMap.get(roomId)));
        }
        
        // 1:1 메시지방 유저 정보로 업데이트
        roomResponses.forEach(roomResponse -> {
            updateUserInfo(roomResponse, userMap, userId);
        });

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
                            .findFirst().orElse(null));
            if (!Objects.isNull(otherUser)) {
                roomResponse.setName(otherUser.getName());
                roomResponse.setIcon(otherUser.getImage());
                String state = UserStateUtil.status.get(otherUser.getId());
                if (Objects.isNull(state))
                    state = "offline";
                roomResponse.setState(state);
            } else {
                roomResponse.setName("대화상대 없음");
                roomResponse.setState("offline");
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
                roomDetailResponse.setIcon(otherUser.getImage());
            }
        }
    }

    @Transactional
    public RoomDetailResponse createRoom(Long userId, CreateRoomRequest request, String token) {

        List<RoomMember> members = new ArrayList<>();

        if (request.getMembers().contains(userId))
            throw new CustomException(CANT_INVITE_SELF);

        // 유저 정보 요청
        List<Long> ids = request.getMembers();
        ids.add(userId);
        if (ids.size() == 1)
            throw new CustomException(MEMBER_REQUIRED);

        HashMap<Long, UserResponse> userMap = getUserMap(ids, token);

        // 1:1일 경우 기존에 존재하는 채팅방 제공
        if (request.getMembers().size() == 2) {
            Room savedRoom = roomMemberRepository.findByUserId(ids.get(0)).stream()
                    .map(RoomMember::getRoom)
                    .filter(r -> !r.getIsGroup())
                    .filter(r -> r.getMembers().stream()
                            .map(RoomMember::getUserId)
                            .collect(Collectors.toList())
                            .contains(userId))
                    .findAny().orElse(null);

            // 존재하는 채팅방이 있으면 기존 채팅방 제공
            if (!Objects.isNull(savedRoom)) {
                savedRoom.getMembers().forEach(rm -> {
                    rm.setStatus(CommonStatus.NORMAL);
                });
                return getRoomDetail(savedRoom, userMap, userId);
            }
        }

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

        String iconImage = amazonS3Connector.getRandomImage();
        Room newRoom = Room.createRoom(name, members, iconImage);
        roomRepository.save(newRoom);

        return getRoomDetail(newRoom, userMap, userId);
    }

    private RoomDetailResponse getRoomDetail(Room room, HashMap<Long, UserResponse> userMap, Long userId) {
        RoomDetailResponse roomDetailResponse = RoomDetailResponse.fromEntity(room);
        roomDetailResponse.setMembers(room.getMembers().stream()
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
                .filter(roomMember -> roomMember.getStatus().equals(CommonStatus.NORMAL))
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

    @Transactional
    public RoomDetailResponse join(Long userId, JoinRequest request, String token) {
        LocalDateTime now = LocalDateTime.now();

        RoomInvitation invitation = roomInvitationRepository.findByCode(request.getCode()).stream()
                .filter(i -> i.getExpiredAt().isAfter(now))
                .filter(i -> i.getCode().equals(request.getCode()))
                .findAny().orElseThrow(() -> new CustomException(NON_VALID_INVITATION));

        // 중복 초대 확인
        Room room = invitation.getRoom();

        if (!room.getStatus().equals(CommonStatus.NORMAL))
            throw new CustomException(NON_VALID_ROOM);

        checkDuplicatedMember(room, userId);
        room.addMember(RoomMember.createRoomMember(userId, false));

        return getRoom(userId, room.getId(), token);
    }

    private void checkDuplicatedMember(Room room, Long userId) {
        boolean isDuplicated = room.getMembers().stream()
                .filter(rm -> rm.getStatus().equals(CommonStatus.NORMAL))
                .map(RoomMember::getUserId)
                .collect(Collectors.toList())
                .contains(userId);

        if (isDuplicated)
            throw new CustomException(ALREADY_INVITED);
    }

    @Transactional
    public void inviteMember(Long userId, InviteMemberRequest request) {
        Room room = roomRepository.findById(request.getId())
                .filter(r -> r.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_ROOM));

        isContain(room, userId);

        for (Long memberId: request.getMembers()) {
            checkDuplicatedMember(room, memberId);
            room.addMember(RoomMember.createRoomMember(memberId, false));
        }
    }

    @Transactional
    public void deleteMember(Long userId, Long roomId, Long memberId) {
        Room room = roomRepository.findById(roomId)
                .filter(r -> r.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_ROOM));

        boolean isOwner = isOwner(room, userId);

        // 추방하기
        if (!userId.equals(memberId)) {
            if (!isOwner)
                throw new CustomException(NON_AUTHORIZATION);
        }

        RoomMember member = room.getMembers().stream()
                .filter(m -> m.getUserId().equals(memberId))
                .filter(m -> m.getStatus().equals(CommonStatus.NORMAL))
                .findAny().orElseThrow(() -> new CustomException(EMPTY_MEMBER));

        member.delete();

        // owner면서 단체 메세지의 경우 다른 유저에게 owner 넘기기
        if (isOwner && room.getIsGroup()) {
            RoomMember otherOwner = room.getMembers().stream()
                    .filter(m -> m.getStatus().equals(CommonStatus.NORMAL))
                    .filter(m -> !m.isOwner())
                    .findAny().orElse(null);

            if (Objects.isNull(otherOwner)) {
                room.delete();
            } else {
                otherOwner.setOwner(true);
            }
        }
    }

    private boolean isOwner(Room room, Long userId) {
        Long ownerId = room.getMembers().stream()
                .filter(rm -> rm.isOwner())
                .findFirst().orElseThrow(() -> new CustomException(NON_EXIST_OWNER))
                .getUserId();

        return ownerId.equals(userId);
    }

    // 채팅방에 따라 연결해야될 시그널링 서버 어드레스 조회
    public AddressResponse getConnectAddress(Long roomId) {
       roomRepository.findById(roomId)
                .filter(r -> r.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_ROOM));

        String address = getInstance(roomId);

        return new AddressResponse(address);
    }

    private String getInstance(Long roomId) {
        List<String> keys = (List<String>) redisTemplate.keys("*").stream()
                .filter(k -> String.valueOf(k).contains("server"))
                .collect(Collectors.toList());

        SetOperations<String, String> setOperations = redisTemplate.opsForSet();
        String leastUsedInstance = keys.get(0);
        int min = -1;
        for (String key: keys) {
            if (setOperations.members(key).contains("r" + roomId))
                return key.split("-")[1];
            if (min < setOperations.members(key).size()) {
                leastUsedInstance = key;
                min = setOperations.members(key).size();
            }
        }
        return leastUsedInstance.split("-")[1];
    }

    // 채팅방에 속한 회원 아이디 리스트 조회
    public MemberListFeignResponse getCommunityMember(Long roomId) {
        Room room = roomRepository.findById(roomId)
                .filter(c -> c.getStatus().equals(CommonStatus.NORMAL))
                .orElseThrow(() -> new CustomException(NON_VALID_ROOM));

        List<Long> ids = room.getMembers().stream()
                .filter(rm -> rm.getStatus().equals(CommonStatus.NORMAL))
                .map(RoomMember::getUserId)
                .collect(Collectors.toList());

        return new MemberListFeignResponse(ids);
    }
}