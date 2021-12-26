package com.example.authserver.controller;

import com.example.authserver.configure.response.DataResponse;
import com.example.authserver.configure.response.ResponseService;
import com.example.authserver.configure.security.authentication.CustomUserDetails;
import com.example.authserver.dto.AccountAutoDto;
import com.example.authserver.dto.SignInRequest;
import com.example.authserver.dto.SignInResponse;
import com.example.authserver.service.AccountService;
import com.example.authserver.util.ValidationExceptionProvider;
import lombok.Getter;
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

}
