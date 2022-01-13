package com.example.communityserver.controller;

import com.example.communityserver.dto.request.*;
import com.example.communityserver.dto.response.*;
import com.example.communityserver.service.CommunityService;
import com.example.communityserver.service.ResponseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/community-server/community")
public class CommunityController {

    private final CommunityService communityService;
    private final ResponseService responseService;

    private final static String ID = "id";
    private final static String AUTHORIZATION = "AUTHORIZATION";

    /**
     * 1. 사용자가 소속된 커뮤니티 리스트 조회
     * 2. 특정 커뮤니티 조회
     * 3. 커뮤니티 생성하기
     * 4. 커뮤니티 이름 수정하기
     * 5. 커뮤니티 아이콘 이미지 수정하기
     * 6. 초대장 만들기
     * 7. 초대장 조회하기
     * 8. 초대장 삭제하기
     * 9. 커뮤니티 멤버 조회하기
     * 10. 초대장으로 커뮤니티 들어오기
     * 11. 멤버 추방하기
     * 12. 멤버 차단하기
     * 13. 커뮤니티 순서 바꾸기
     */

    /**
     * 특정 커뮤니티 조회
     */
    @GetMapping("/{communityId}")
    public DataResponse<CommunityResponse> getCommunity(
            @RequestHeader(ID) String userId,
            @PathVariable Long communityId
    ) {
        log.info("/community-server/community/{}", communityId);
        CommunityResponse response = communityService.getCommunity(Long.parseLong(userId), communityId);
        return responseService.getDataResponse(response);
    }

    /**
     * 커뮤니티 생성하기
     */
    @PostMapping
    public DataResponse<CreateCommunityResponse> createCommunity(
            @RequestHeader(AUTHORIZATION) String token,
            @RequestHeader(ID) String userId,
            @Valid @ModelAttribute CreateCommunityRequest request
    ) {
        log.info("/community-server/community");
        CreateCommunityResponse createCommunityResponse =
                communityService.createCommunity(Long.parseLong(userId), request, token);
        return responseService.getDataResponse(createCommunityResponse);
    }

    /**
     * 커뮤니티 이름 수정하기
     */
    @PatchMapping("/name")
    public CommonResponse editName(
            @RequestHeader(ID) String userId,
            @Valid @RequestBody EditCommunityNameRequest request
    ) {
        log.info("/community-server/community/name");
        communityService.editName(Long.parseLong(userId), request);
        return responseService.getSuccessResponse();
    }

    /**
     * 커뮤니티 아이콘 이미지 수정하기
     */
    @PatchMapping("/icon")
    public CommonResponse editIcon(
            @RequestHeader(ID) String userId,
            @Valid @ModelAttribute EditCommunityIconRequest request
    ) {
        log.info("/community-server/community/icon");
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
        log.info("/community-server/community/invitation");
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
        log.info("/community-server/community/{}/invitation", communityId);
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
        log.info("/community-server/community/invitation");
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
        log.info("/community-server/community/{}/member", communityId);
        MemberListResponse response =
                communityService.getMembers(Long.parseLong(userId), communityId, token);
        return responseService.getDataResponse(response);
    }

    /**
     * 초대장으로 커뮤니티 들어오기
     */
    @PostMapping("/invite")
    public CommonResponse join(
            @RequestHeader(AUTHORIZATION) String token,
            @RequestHeader(ID) String userId,
            @Valid @RequestBody JoinCommunityRequest request
    ) {
        log.info("/community-server/community/invite");
        communityService.join(Long.parseLong(userId), request, token);
        return responseService.getSuccessResponse();
    }

    /**
     * 멤버 추방하기
     */
    @DeleteMapping("/{communityId}/member")
    public CommonResponse deleteMember(
            @RequestHeader(ID) String userId,
            @PathVariable Long communityId,
            @RequestParam(name = "id") Long memberId
    ) {
        log.info("/community-server/community/member");
        communityService.deleteMember(Long.parseLong(userId), communityId, memberId);
        return responseService.getSuccessResponse();
    }

    /**
     * 멤버 차단하기
     */
    @PostMapping("/{communityId}/member/ban")
    public CommonResponse suspendMember(
            @RequestHeader(ID) String userId,
            @PathVariable Long communityId,
            @RequestParam(name = "id") Long memberId
    ) {
        log.info("/community-server/community/member/ban");
        communityService.suspendMember(Long.parseLong(userId), communityId, memberId);
        return responseService.getSuccessResponse();
    }
}
