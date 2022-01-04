package com.example.authserver.controller;

import com.example.authserver.exception.CustomException;
import com.example.authserver.exception.CustomExceptionStatus;
import com.example.authserver.dto.response.CommonResponse;
import com.example.authserver.dto.response.DataResponse;
import com.example.authserver.service.ResponseService;
import com.example.authserver.configure.security.authentication.CustomUserDetails;
import com.example.authserver.domain.type.RoleType;
import com.example.authserver.dto.*;
import com.example.authserver.dto.request.SignInRequest;
import com.example.authserver.dto.response.MailResponse;
import com.example.authserver.dto.response.SignInResponse;
import com.example.authserver.service.AccountService;
import com.example.authserver.util.ValidationExceptionProvider;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@Slf4j
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
    public DataResponse<AccountAutoDto> getAuthAccount(@AuthenticationPrincipal CustomUserDetails customUserDetails,
                                                       @RequestHeader("id") String id) {
        log.info(id);
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

}
