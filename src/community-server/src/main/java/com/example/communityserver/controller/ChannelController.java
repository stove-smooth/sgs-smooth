package com.example.communityserver.controller;

import com.example.communityserver.dto.request.CreateChannelRequest;
import com.example.communityserver.dto.request.EditDescRequest;
import com.example.communityserver.dto.request.EditNameRequest;
import com.example.communityserver.dto.response.ChannelResponse;
import com.example.communityserver.dto.response.CommonResponse;
import com.example.communityserver.dto.response.DataResponse;
import com.example.communityserver.service.ChannelService;
import com.example.communityserver.service.ResponseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

import static com.example.communityserver.controller.CommunityController.ID;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/community-server/channel")
public class ChannelController {

    private final ChannelService channelService;
    private final ResponseService responseService;

    /**
     * 0. 채널 정보 조회하기
     * 1. 채널 생성하기
     * 2. 채널 이름 수정하기
     * 3. 채널 소개 편집하기
     * 4. 카테고리 배치 순서 바꾸기
     * 5. 채널 삭제하기
     * 6. 채널에 초대하기
     * 7. 채널에서 추방하기
     * 8. 채널 복제하기
     * 9. 채널 내 메세지 읽음 처리 (Optional)
     */

    /**
     * 채널 정보 조회하기
     */

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
     * 카테고리 배치 순서 바꾸기
     */

    /**
     * 채널 삭제하기
     */

    /**
     * 채널에 초대하기
     */

    /**
     * 채널에서 추방하기
     */

    /**
     * 채널 복제하기
     */

    /**
     * 채널 내 메세지 읽음 처리 (Optional)
     */

}
