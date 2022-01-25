package com.example.communityserver.controller;

import com.example.communityserver.dto.request.CreateRoomRequest;
import com.example.communityserver.dto.response.DataResponse;
import com.example.communityserver.dto.response.RoomDetailResponse;
import com.example.communityserver.dto.response.RoomListResponse;
import com.example.communityserver.dto.response.RoomResponse;
import com.example.communityserver.service.ResponseService;
import com.example.communityserver.service.RoomService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

import static com.example.communityserver.controller.CommunityController.AUTHORIZATION;
import static com.example.communityserver.controller.CommunityController.ID;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/community-server/room")
public class RoomController {

    private final RoomService roomService;
    private final ResponseService responseService;

    /**
     * 1. 채팅방 리스트 가져오기
     * 2. 채팅방 생성하기
     * 3. 채팅방 정보 가져오기
     * 4. 채팅방 이름 바꾸기
     * 5. 채팅방 아이콘 바꾸기
     * 6. 채팅방에 초대하기
     * 7. 채팅방에서 나가기(추방하기)
     */

    /**
     * 채팅방 리스트 가져오기
     */
    @GetMapping
    public DataResponse<RoomListResponse> getRooms(
            @RequestHeader(AUTHORIZATION) String token,
            @RequestHeader(ID) String userId
    ) {
        log.info("GET /community-server/room");
        return responseService.getDataResponse(roomService.getRooms(Long.parseLong(userId), token));
    }

    /**
     * 채팅방 생성하기
     */
    public DataResponse<RoomDetailResponse> createRoom(
            @RequestHeader(AUTHORIZATION) String token,
            @RequestHeader(ID) String userId,
            @Valid @RequestBody CreateRoomRequest request
    ) {
        log.info("POST /community-server/room");
        return responseService.getDataResponse(roomService.createRoom(Long.parseLong(userId), request, token));
    }
}
