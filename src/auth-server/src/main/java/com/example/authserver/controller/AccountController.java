package com.example.authserver.controller;

import com.example.authserver.configure.exception.CustomException;
import com.example.authserver.configure.exception.CustomExceptionStatus;
import com.example.authserver.configure.response.CommonResponse;
import com.example.authserver.configure.response.DataResponse;
import com.example.authserver.configure.response.ResponseService;
import com.example.authserver.configure.security.authentication.CustomUserDetails;
import com.example.authserver.domain.RoleType;
import com.example.authserver.dto.*;
import com.example.authserver.service.AccountService;
import com.example.authserver.util.ValidationExceptionProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/auth-server")
public class AccountController {

    private final AccountService accountService;
    private final ResponseService responseService;

    @PostMapping("/sign-up")
    public DataResponse<AccountAutoDto> signUp(@RequestBody @Valid AccountAutoDto dto, Errors errors) {
        if (errors.hasErrors()) ValidationExceptionProvider.throwValidError(errors);

        return responseService.getDataResponse(accountService.signUp(dto));
    }

    @PostMapping("/sign-in")
    public DataResponse<SignInResponse> signIn(@RequestBody @Valid SignInRequest request, Errors errors) {
        if (errors.hasErrors()) ValidationExceptionProvider.throwValidError(errors);
        return responseService.getDataResponse(accountService.signIn(request));
    }

    @GetMapping("/info")
    public DataResponse<AccountAutoDto> getAuthAccount(@AuthenticationPrincipal CustomUserDetails customUserDetails) {
        return responseService.getDataResponse(accountService.getAuthAccount(customUserDetails));
    }

    @PostMapping("/send-mail")
    public DataResponse<MailResponse> sendEmail(@RequestParam(value = "email") String email) {
        return responseService.getDataResponse(accountService.sendEmail(email));
    }

    @GetMapping("/check-email/{key}")
    public CommonResponse checkEmail(@PathVariable String key) {
        accountService.checkEmail(key);

        return responseService.getSuccessResponse();
    }

    @PatchMapping("/role")
    public CommonResponse updateRole(@RequestParam(value = "email") String email,
                                     @RequestParam(value = "role") String role) {
        RoleType roleType;

        try {
            roleType = RoleType.valueOf("ROLE_" + role);
        } catch (IllegalArgumentException e) {
            throw new CustomException(CustomExceptionStatus.ACCOUNT_NOT_VALID_ROLE);
        }
        accountService.updateRole(email,roleType);
        return responseService.getSuccessResponse();
    }

    @PostMapping("/refresh")
    public DataResponse<SignInResponse> refreshToken(@RequestHeader("AUTHORIZATION") String token,
                                                     @RequestHeader("REFRESH-TOKEN") String refreshToken) {
        return responseService.getDataResponse(accountService.checkRefreshToken(token,refreshToken));
    }

    @PostMapping("/friend")
    public CommonResponse requestFriend(@RequestBody @Valid FriendRequest friendRequest, Errors errors,
                                        @AuthenticationPrincipal CustomUserDetails customUserDetails) {
        if (errors.hasErrors()) ValidationExceptionProvider.throwValidError(errors);
        accountService.requestFriend(friendRequest,customUserDetails);

        return responseService.getSuccessResponse();
    }



}
