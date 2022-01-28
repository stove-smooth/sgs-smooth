package com.example.communityserver.controller;

import com.example.communityserver.dto.request.*;
import com.example.communityserver.dto.response.*;
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
     * 6. 채팅방 초대장 만들기
     * 7. 초대장으로 채팅방 들어오기
     * 8. 채팅방에 초대하기
     * 9. 채팅방에서 나가기(추방하기)
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
    @PostMapping
    public DataResponse<RoomDetailResponse> createRoom(
            @RequestHeader(AUTHORIZATION) String token,
            @RequestHeader(ID) String userId,
            @Valid @RequestBody CreateRoomRequest request
    ) {
        log.info("POST /community-server/room");
        return responseService.getDataResponse(roomService.createRoom(Long.parseLong(userId), request, token));
    }

    /**
     * 채팅방 정보 가져오기
     */
    @GetMapping("/{roomId}")
    public DataResponse<RoomDetailResponse> getRoom(
            @RequestHeader(AUTHORIZATION) String token,
            @RequestHeader(ID) String userId,
            @PathVariable Long roomId
    ) {
        log.info("GET /community-server/room/{}", roomId);
        return responseService.getDataResponse(roomService.getRoom(Long.parseLong(userId), roomId, token));
    }

    /**
     * 채팅방 이름 바꾸기
     */
    @PatchMapping("/name")
    public CommonResponse editName(
            @RequestHeader(ID) String userId,
            @Valid @RequestBody EditNameRequest request
    ) {
        log.info("PATCH /community-server/room/name");
        roomService.editName(Long.parseLong(userId), request);
        return responseService.getSuccessResponse();
    }

    /**
     * 채팅방 아이콘 바꾸기
     */
    @PatchMapping("/icon")
    public CommonResponse editIcon(
            @RequestHeader(ID) String userId,
            @Valid @ModelAttribute EditIconRequest request
    ) {
        log.info("PATCH /community-server/room/icon");
        roomService.editIcon(Long.parseLong(userId), request);
        return responseService.getSuccessResponse();
    }

    /**
     * 채팅방 초대장 만들기
     */
    @PostMapping("/invitation")
    public DataResponse<CreateInvitationResponse> createRoomInvitation(
            @RequestHeader(ID) String userId,
            @Valid @RequestBody CreateInvitationRequest request
    ) {
        log.info("POST /community-server/room/invitation");
        return responseService.getDataResponse(roomService.createInvitation(Long.parseLong(userId), request));
    }

    /**
     * 초대장으로 채팅방 들어오기
     */
    @PatchMapping("/member")
    public DataResponse<RoomDetailResponse> join(
            @RequestHeader(AUTHORIZATION) String token,
            @RequestHeader(ID) String userId,
            @Valid @RequestBody JoinRequest request
    ) {
        log.info("PATCH /community-server/room/member");
        return responseService.getDataResponse(roomService.join(Long.parseLong(userId), request, token));
    }

    /**
     * 채팅방에 추가하기
     */
    @PostMapping("/member")
    public CommonResponse inviteMember(
            @RequestHeader(ID) String userId,
            @Valid @RequestBody InviteMemberRequest request
    ) {
        log.info("POST /community-server/room/member");
        roomService.inviteMember(Long.parseLong(userId), request);
        return responseService.getSuccessResponse();
    }

    /**
     * 채팅방에서 나가기(추방하기)
     */
    @DeleteMapping("/{roomId}/member")
    public CommonResponse deleteMember(
            @RequestHeader(ID) String userId,
            @PathVariable Long roomId,
            @RequestParam(name = "id") Long memberId
    ) {
        log.info("DELETE /community-server/room/{}/member", roomId);
        roomService.deleteMember(Long.parseLong(userId), roomId, memberId);
        return responseService.getSuccessResponse();
    }

    @GetMapping("{roomId}/address")
    public DataResponse<AddressResponse> getConnectAddress(
            @RequestHeader(ID) String userId,
            @PathVariable Long roomId
    ) {
        log.info("GET /community-server/room/{}/address", roomId);
        AddressResponse response = roomService.getConnectAddress(Long.parseLong(userId), roomId);
        return responseService.getDataResponse(response);
    }
}