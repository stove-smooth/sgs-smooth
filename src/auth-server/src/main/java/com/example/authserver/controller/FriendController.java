package com.example.authserver.controller;

import com.example.authserver.configure.response.CommonResponse;
import com.example.authserver.configure.response.DataResponse;
import com.example.authserver.configure.response.ResponseService;
import com.example.authserver.configure.security.authentication.CustomUserDetails;
import com.example.authserver.dto.FriendRequest;
import com.example.authserver.dto.WaitingResponse;
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

    @PostMapping("/friend/request")
    public CommonResponse requestFriend(@RequestBody @Valid FriendRequest friendRequest, Errors errors,
                                        @AuthenticationPrincipal CustomUserDetails customUserDetails) {
        if (errors.hasErrors()) ValidationExceptionProvider.throwValidError(errors);
        friendService.requestFriend(friendRequest,customUserDetails);

        return responseService.getSuccessResponse();
    }

    @GetMapping("/friend/request")
    public DataResponse<WaitingResponse> getFriendRequest(@AuthenticationPrincipal CustomUserDetails customUserDetails) {
        return responseService.getDataResponse(friendService.getFriendRequest(customUserDetails));
    }

    //todo : 친구요청 취소, 거절

    //todo : 친구리스트 보여주기
}
