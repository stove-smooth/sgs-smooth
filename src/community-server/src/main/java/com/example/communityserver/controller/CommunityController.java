package com.example.communityserver.controller;

import com.example.communityserver.dto.request.CreateCommunityRequest;
import com.example.communityserver.dto.request.EditCommunityNameRequest;
import com.example.communityserver.dto.response.CreateCommunityResponse;
import com.example.communityserver.dto.response.DataResponse;
import com.example.communityserver.service.CommunityService;
import com.example.communityserver.service.ResponseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.Valid;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/community-server/community")
public class CommunityController {

    private final CommunityService communityService;
    private final ResponseService responseService;

    /**
     * 1. 메인 - 사용자의 커뮤니티 정보 조회하기
     * 2. 커뮤니티 생성하기
     * 3. 커뮤니티 이름 수정하기
     * 4. 커뮤니티 아이콘 이미지 수정하기
     * 5. 초대장 만들기
     * 6. 초대장 조회하기
     * 7. 커뮤니티 멤버 조회하기
     * 8. 초대장으로 커뮤니티 들어오기
     * 9. 멤버 추방하기
     * 10. 멤버 차단하기
     */

    /**
     * 1. 메인 - 사용자의 커뮤니티 정보 조회하기
     */
//    @GetMapping("/{communityId}/{channelId}")
//    public void getMainInfo() {
//
//    }

    /**
     * 2. 커뮤니티 생성하기
     */
    @PostMapping
    public DataResponse<CreateCommunityResponse> createCommunity(
            @RequestHeader("AUTHORIZATION") String token,
            @RequestHeader("id") String userId,
            @Valid @ModelAttribute CreateCommunityRequest request
    ) {
        log.info("/community-server/community");

        CreateCommunityResponse createCommunityResponse =
                communityService.createCommunity(Long.parseLong(userId), request, token);

        return responseService.getDataResponse(createCommunityResponse);
    }

    /**
     * 3. 커뮤니티 이름 수정하기
     */
    @PatchMapping("/name")
    public void editName(@Valid @RequestBody EditCommunityNameRequest request) {
        log.info("/community-server/community/name");
        // communityService.editName(request);
        // return responseService
    }

    /**
     * 4. 커뮤니티 아이콘 이미지 수정하기
     */
//    @PatchMapping("/icon")
//    public void editIcon() {
//
//    }

    /**
     * 5. 초대장 만들기
     */
//    @PostMapping("/invitation")
//    public void createInvitation() {
//
//    }

    /**
     * 6. 초대장 조회하기
     */
//    @GetMapping("/{communityId}/invitation")
//    public void getInvitations() {
//
//    }

    /**
     * 7. 커뮤니티 멤버 조회하기
     */
//    @GetMapping("/{communityId}/member")
//    public void getMembers() {
//          // Mapper 부르고 user service에 open feign
//    }

    /**
     * 8. 초대장으로 커뮤니티 들어오기
     */
//    @PostMapping("/member")
//    public void joinByInvitation() {
//
//    }

    /**
     * 9. 멤버 추방하기
     */
//    @DeleteMapping("/member")
//    public void deleteMember() {
//
//    }

    /**
     * 10. 멤버 차단하기
     */
//    @PostMapping("/member/ban")
//    public void suspendMember() {
//
//    }
}
