package com.example.authserver.controller;

import com.example.authserver.dto.response.CommonResponse;
import com.example.authserver.dto.response.DataResponse;
import com.example.authserver.service.ResponseService;
import com.example.authserver.configure.security.authentication.CustomUserDetails;
import com.example.authserver.dto.request.FriendRequest;
import com.example.authserver.dto.response.WaitingResponse;
import com.example.authserver.service.FriendService;
import com.example.authserver.util.ValidationExceptionProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/auth-server")
public class FriendController {

    private final FriendService friendService;
    private final ResponseService responseService;

    @PostMapping("/friend")
    public CommonResponse requestFriend(@RequestBody @Valid FriendRequest friendRequest, Errors errors,
                                        @AuthenticationPrincipal CustomUserDetails customUserDetails) {
        if (errors.hasErrors()) ValidationExceptionProvider.throwValidError(errors);
        friendService.requestFriend(friendRequest,customUserDetails);

        return responseService.getSuccessResponse();
    }

    @GetMapping("/friend")
    public DataResponse<WaitingResponse> getFriendRequest(@AuthenticationPrincipal CustomUserDetails customUserDetails) {
        return responseService.getDataResponse(friendService.getFriendRequest(customUserDetails.getAccount().getId()));
    }

    @PatchMapping("/friend")
    public CommonResponse addToFriend(@RequestParam(value="id") Long id) {
        friendService.addToFriend(id);

        return responseService.getSuccessResponse();
    }

    @DeleteMapping("/friend")
    public CommonResponse refuseFriend(@RequestParam(value = "id") Long id) {
        friendService.refuseFriend(id);
        return responseService.getSuccessResponse();
    }
}
