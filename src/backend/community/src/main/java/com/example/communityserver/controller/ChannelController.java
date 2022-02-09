package com.example.communityserver.controller;

import com.example.communityserver.dto.request.*;
import com.example.communityserver.dto.response.*;
import com.example.communityserver.service.ChannelService;
import com.example.communityserver.service.ResponseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

import static com.example.communityserver.controller.CommunityController.AUTHORIZATION;
import static com.example.communityserver.controller.CommunityController.ID;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/community-server/channel")
public class ChannelController {

    private final ChannelService channelService;
    private final ResponseService responseService;

    /**
     * 채널 정보 조회하기
     */
    @GetMapping("{channelId}")
    public DataResponse<ChannelDetailResponse> getChannelDetail(
            @RequestHeader(AUTHORIZATION) String token,
            @RequestHeader(ID) String userId,
            @PathVariable Long channelId
    ) {
        log.info("GET /community-server/channel/{}", channelId);
        ChannelDetailResponse response =
                channelService.getChannelDetail(Long.parseLong(userId), channelId, token);
        return responseService.getDataResponse(response);
    }

    /**
     * 채널 생성하기
     */
    @PostMapping
    public DataResponse<ChannelResponse> createChannel(
            @RequestHeader(ID) String userId,
            @Valid @RequestBody CreateChannelRequest request
    ) {
        log.info("POST /community-server/channel");
        ChannelResponse response =
                channelService.createChannel(Long.parseLong(userId), request);
        return responseService.getDataResponse(response);
    }

    /**
     * 스레드 만들기
     */
    @PostMapping("/thread")
    public DataResponse<ChannelResponse> createThread(
            @RequestHeader(AUTHORIZATION) String token,
            @RequestHeader(ID) String userId,
            @Valid @RequestBody CreateThreadRequest request
    ) {
        log.info("POST /community-server/channel/thread");
        ChannelResponse response =
                channelService.createThread(Long.parseLong(userId), request, token);
        return responseService.getDataResponse(response);
    }

    /**
     * 채널 이름 수정하기
     */
    @PatchMapping("/name")
    public CommonResponse editName(
            @RequestHeader(ID) String userId,
            @Valid @RequestBody EditNameRequest request
    ) {
        log.info("PATCH /community-server/channel/name");
        channelService.editName(Long.parseLong(userId), request);
        return responseService.getSuccessResponse();
    }

    /**
     * 채널 소개 편집하기
     */
    @PatchMapping("/desc")
    public CommonResponse editDescription(
            @RequestHeader(ID) String userId,
            @Valid @RequestBody EditDescRequest request
    ) {
        log.info("PATCH /community-server/channel/desc");
        channelService.editDescription(Long.parseLong(userId), request);
        return responseService.getSuccessResponse();
    }

    /**
     * 채널 배치 순서 바꾸기
     */
    @PatchMapping("/location")
    public CommonResponse locateChannel(
            @RequestHeader(ID) String userId,
            @Valid @RequestBody LocateChannelRequest request
    ) {
        log.info("PATCH /community-server/channel/location");
        channelService.locateChannel(Long.parseLong(userId), request);
        return responseService.getSuccessResponse();
    }

    /**
     * 채널 삭제하기
     */
    @DeleteMapping("/{channelId}")
    public CommonResponse deleteChannel(
            @RequestHeader(ID) String userId,
            @PathVariable Long channelId
    ) {
        log.info("DELETE /community-server/channel/{}", channelId);
        channelService.deleteChannel(Long.parseLong(userId), channelId);
        return responseService.getSuccessResponse();
    }

    /**
     * 채널에 멤버 추가하기
     */
    @PostMapping("/member")
    public CommonResponse inviteMember(
            @RequestHeader(ID) String userId,
            @Valid @RequestBody InviteMemberRequest request
    ) {
        log.info("POST /community-server/channel/member");
        channelService.inviteMember(Long.parseLong(userId), request);
        return responseService.getSuccessResponse();
    }

    /**
     * 채널에서 추방하기
     */
    @DeleteMapping("/{channelId}/member")
    public CommonResponse deleteMember(
            @RequestHeader(ID) String userId,
            @PathVariable Long channelId,
            @RequestParam(name = "id") Long memberId
    ) {
        log.info("DELETE /community-server/channel/member");
        channelService.deleteMember(Long.parseLong(userId), channelId, memberId);
        return responseService.getSuccessResponse();
    }

    /**
     * 채널 복제하기
     */
    @PostMapping("/copy")
    public DataResponse<ChannelResponse> copy(
            @RequestHeader(ID) String userId,
            @Valid @RequestBody CopyChannelRequest request
    ) {
        log.info("POST /community-server/channel/copy");
        ChannelResponse response = channelService.copy(Long.parseLong(userId), request);
        return responseService.getDataResponse(response);
    }

    /**
     * TODO 연결해야 할 시그널링 서버 알려주기
     */
    @GetMapping("/{channelId}/address")
    public DataResponse<AddressResponse> getConnectAddress(
            @RequestHeader(ID) String userId,
            @PathVariable Long channelId
    ) {
        log.info("GET /community-server/channel/{}/address", channelId);
        AddressResponse response = channelService.getConnectAddress(Long.parseLong(userId), channelId);
        return responseService.getDataResponse(response);
    }

    /**
     * 채널 내 메세지 읽음 처리 (Optional)
     */

}
