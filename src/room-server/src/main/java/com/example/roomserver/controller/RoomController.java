package com.example.roomserver.controller;

import com.example.roomserver.dto.response.DataResponse;
import com.example.roomserver.dto.response.RoomListResponse;
import com.example.roomserver.service.ResponseService;
import com.example.roomserver.service.RoomService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/room-service")
public class RoomController {

    private final RoomService roomService;
    private final ResponseService responseService;

    /**
     * 1. 메세지 리스트 가져오기
     * 2. 메시지 그룹 존재하는지 확인
     * 3. 메세지 생성하기
     * 4. 메세지 멤버 목록 불러오기
     * 5. 메세지 그룹에 초대하기
     * 6. 메세지 그룹에서 추방하기
     * 7. 메세지 그룹 이름 바꾸기
     * 8. 메세지 그룹 아이콘 바꾸기
     */

    /**
     * 메세지 리스트 가져오기
     */
    @GetMapping("/room")
    public DataResponse<RoomListResponse> getRooms(@RequestHeader("id") String accountId) {
        log.info("GET /room");
        return responseService.getDataResponse(roomService.getRooms(Long.parseLong(accountId)));
    }
}
