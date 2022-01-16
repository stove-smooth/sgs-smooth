package com.example.communityserver.controller;

import com.example.communityserver.dto.request.*;
import com.example.communityserver.dto.response.CommonResponse;
import com.example.communityserver.service.CategoryService;
import com.example.communityserver.service.ResponseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

import static com.example.communityserver.controller.CommunityController.ID;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/community-server/category")
public class CategoryController {

    /**
     * Todo 카테고리 내 메세지 읽음 처리 (Optional)
     */

    private final CategoryService categoryService;
    private final ResponseService responseService;

    /**
     * 1. 카테고리 생성하기
     */
    @PostMapping
    public CommonResponse createCategory(
            @RequestHeader(ID) String userId,
            @Valid @RequestBody CreateCategoryRequest request
    ) {
        log.info("POST /community-server/category");
        categoryService.createCategory(Long.parseLong(userId), request);
        return responseService.getSuccessResponse();
    }

    /**
     * 2. 카테고리 이름 수정하기
     */
    @PatchMapping("/name")
    public CommonResponse editName(
            @RequestHeader(ID) String userId,
            @Valid @RequestBody EditNameRequest request
    ) {
        log.info("PATCH /community-server/category/name");
        categoryService.editName(Long.parseLong(userId), request);
        return responseService.getSuccessResponse();
    }

    /**
     * 3. 카테고리 배치 순서 바꾸기
     */
    @PatchMapping("/location")
    public CommonResponse locateCategory(
            @RequestHeader(ID) String userId,
            @Valid @RequestBody LocateCategoryRequest request
    ) {
        log.info("PATCH /community-server/category/location");
        categoryService.locateCategory(Long.parseLong(userId), request);
        return responseService.getSuccessResponse();
    }

    /**
     * 4. 카테고리 삭제하기
     */
    @DeleteMapping("/{categoryId}")
    public CommonResponse deleteCategory(
            @RequestHeader(ID) String userId,
            @PathVariable Long categoryId
    ) {
        log.info("DELETE /community-server/category/{}", categoryId);
        categoryService.deleteCategory(Long.parseLong(userId), categoryId);
        return responseService.getSuccessResponse();
    }


    /**
     * 5. 카테고리에 멤버 추가하기
     */
    @PostMapping("/member")
    public CommonResponse inviteMember(
            @RequestHeader(ID) String userId,
            @Valid @RequestBody InviteMemberRequest request
    ) {
        log.info("POST /community-server/category/member");
        categoryService.inviteMember(Long.parseLong(userId), request);
        return responseService.getSuccessResponse();
    }

    /**
     * 6. 카테고리에서 추방하기
     */
    @DeleteMapping("/{categoryId}/member")
    public CommonResponse deleteMember(
            @RequestHeader(ID) String userId,
            @PathVariable Long categoryId,
            @RequestParam(name = "id") Long memberId
    ) {
        log.info("DELETE /community-server/category/{}/member", categoryId);
        categoryService.deleteMember(Long.parseLong(userId), categoryId, memberId);
        return responseService.getSuccessResponse();
    }

    /**
     * 7. 카테고리 내 메세지 읽음 처리 (Optional)
     */
}
