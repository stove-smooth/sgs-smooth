package com.example.communityserver.controller;

import com.example.communityserver.dto.request.*;
import com.example.communityserver.dto.response.*;
import com.example.communityserver.service.CommunityService;
import com.example.communityserver.service.ResponseService;
import com.example.communityserver.util.DataCorrectionUtil;
import com.example.communityserver.util.UserStateUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/community-server/community")
public class CommunityController {

    private final CommunityService communityService;
    private final ResponseService responseService;
    private final DataCorrectionUtil dataCorrectionUtil;

    public static final String ID = "id";
    public static final String AUTHORIZATION = "AUTHORIZATION";

    /**
     * 사용자가 소속된 커뮤니티 리스트 조회
     */
    @GetMapping()
    public DataResponse<MainResponse> getCommunityList(
            @RequestHeader(AUTHORIZATION) String token,
            @RequestHeader(ID) String userId
    ) {
        log.info("GET /community-server/community");
        MainResponse response = communityService.getCommunityList(Long.parseLong(userId), token);
        return responseService.getDataResponse(response);
    }

    /**
     * 특정 커뮤니티 조회
     */
    @GetMapping("/{communityId}")
    public DataResponse<CommunityDetailResponse> getCommunityDetail(
            @RequestHeader(ID) String userId,
            @PathVariable Long communityId
    ) {
        log.info("GET /community-server/community/{}", communityId);
        CommunityDetailResponse response = communityService.getCommunityInfo(Long.parseLong(userId), communityId);
        return responseService.getDataResponse(response);
    }

    /**
     * 커뮤니티 생성하기
     */
    @PostMapping
    public DataResponse<CommunityResponse> createCommunity(
            @RequestHeader(AUTHORIZATION) String token,
            @RequestHeader(ID) String userId,
            @Valid @ModelAttribute CreateCommunityRequest request
    ) {
        log.info("POST /community-server/community");

        CommunityResponse response =
                communityService.createCommunity(Long.parseLong(userId), request, token);

        // 채팅 서버에 변동 정보 전송
        dataCorrectionUtil.updateCommunityMember(response.getId());

        return responseService.getDataResponse(response);
    }

    /**
     * 커뮤니티 이름 수정하기
     */
    @PatchMapping("/name")
    public CommonResponse editName(
            @RequestHeader(ID) String userId,
            @Valid @RequestBody EditNameRequest request
    ) {
        log.info("PATCH /community-server/community/name");
        communityService.editName(Long.parseLong(userId), request);
        return responseService.getSuccessResponse();
    }

    /**
     * 커뮤니티 아이콘 이미지 수정하기
     */
    @PatchMapping("/icon")
    public CommonResponse editIcon(
            @RequestHeader(ID) String userId,
            @Valid @ModelAttribute EditIconRequest request
    ) {
        log.info("PATCH /community-server/community/icon");
        communityService.editIcon(Long.parseLong(userId), request);
        return responseService.getSuccessResponse();
    }

    /**
     * 초대장 만들기
     */
    @PostMapping("/invitation")
    public DataResponse<CreateInvitationResponse> invite(
            @RequestHeader(ID) String userId,
            @Valid @RequestBody CreateInvitationRequest request
    ) {
        log.info("POST /community-server/community/invitation");
        CreateInvitationResponse createInvitationResponse =
                communityService.createInvitation(Long.parseLong(userId), request);
        return responseService.getDataResponse(createInvitationResponse);
    }

    /**
     * 초대장 조회하기
     */
    @GetMapping("/{communityId}/invitation")
    public DataResponse<InvitationListResponse> getInvitations(
            @RequestHeader(AUTHORIZATION) String token,
            @RequestHeader(ID) String userId,
            @PathVariable Long communityId
    ) {
        log.info("GET /community-server/community/{}/invitation", communityId);
        InvitationListResponse response = communityService.getInvitations(Long.parseLong(userId), communityId, token);
        return responseService.getDataResponse(response);
    }

    /**
     * 초대장 삭제하기
     */
    @DeleteMapping("/invitation")
    public CommonResponse deleteInvitations(
            @RequestHeader(ID) String userId,
            @RequestParam(name = "id") Long invitationId
    ) {
        log.info("DELETE /community-server/community/invitation");
        communityService.deleteInvitation(Long.parseLong(userId), invitationId);
        return responseService.getSuccessResponse();
    }

    /**
     * 커뮤니티 멤버 조회하기
     */
    @GetMapping("/{communityId}/member")
    public DataResponse<MemberListResponse> getMembers(
            @RequestHeader(AUTHORIZATION) String token,
            @RequestHeader(ID) String userId,
            @PathVariable Long communityId
    ) {
        log.info("GET /community-server/community/{}/member", communityId);
        MemberListResponse response =
                communityService.getMembers(Long.parseLong(userId), communityId, token);
        return responseService.getDataResponse(response);
    }

    /**
     * 초대장으로 커뮤니티 들어오기
     */
    @PostMapping("/member")
    public DataResponse<CommunityResponse> join(
            @RequestHeader(AUTHORIZATION) String token,
            @RequestHeader(ID) String userId,
            @Valid @RequestBody JoinRequest request
    ) {
        log.info("POST /community-server/community/member");

        CommunityResponse response = communityService.join(Long.parseLong(userId), request, token);

        // 채팅 서버에 변동 정보 전송
        dataCorrectionUtil.updateCommunityMember(response.getId());

        return responseService.getDataResponse(response);
    }

    /**
     * 커뮤니티 나가기(멤버 추방하기)
     */
    @DeleteMapping("/{communityId}/member")
    public CommonResponse deleteMember(
            @RequestHeader(ID) String userId,
            @PathVariable Long communityId,
            @RequestParam(name = "id") Long memberId
    ) {
        log.info("DELETE /community-server/community/{}/member", communityId);

        communityService.deleteMember(Long.parseLong(userId), communityId, memberId);

        // 채팅 서버에 변동 정보 전송
        dataCorrectionUtil.updateCommunityMember(communityId);

        return responseService.getSuccessResponse();
    }

    /**
     * 멤버 차단하기
     */
    @DeleteMapping("/{communityId}/member/ban")
    public CommonResponse suspendMember(
            @RequestHeader(ID) String userId,
            @PathVariable Long communityId,
            @RequestParam(name = "id") Long memberId
    ) {
        log.info("DELETE /community-server/community/member/ban");
        communityService.suspendMember(Long.parseLong(userId), communityId, memberId);
        return responseService.getSuccessResponse();
    }

    /**
     * 커뮤니티 순서 변경
     */
    @PatchMapping("/location")
    public CommonResponse locateCommunity(
            @RequestHeader(ID) String userId,
            @Valid @RequestBody LocateRequest request
    ) {
        log.info("PATCH /community-server/community/location");
        communityService.locateCommunity(Long.parseLong(userId), request);
        return responseService.getSuccessResponse();
    }

    /**
     * 커뮤니티 삭제하기
     */
    @DeleteMapping("/{communityId}")
    public CommonResponse deleteCommunity(
            @RequestHeader(ID) String userId,
            @PathVariable Long communityId
    ) {
        log.info("DELETE /community-server/community/{}", communityId);
        communityService.deleteCommunity(Long.parseLong(userId), communityId);
        return responseService.getSuccessResponse();
    }

    /**
     * 커뮤니티에 속한 회원 아이디 찾기
     */
    @GetMapping("/feign/{communityId}/member-id")
    public DataResponse<MemberListFeignResponse> getCommunityMember(
            @PathVariable Long communityId
    ) {
        log.info("GET /community-server/community/feign/{}/member", communityId);
        return responseService.getDataResponse(communityService.getCommunityMember(communityId));
    }

    /**
     * 사용자가 속한 커뮤니티, 룸 리스트 조회
     */
    @GetMapping("/feign/room-list/{userId}")
    public List<String> getIncludeRoomList(
            @PathVariable Long userId
    ) {
        log.info("GET /community-server/community/feign/room-list/{}", userId);
        return communityService.getIncludeRoomList(userId);
    }

    /**
     * 현재 메모리에 저장된 사용자 접속 정보 조회
     */
    @GetMapping("/test/member-state")
    public Map<Long, String> getMemberState() {
        return UserStateUtil.status;
    }
}
