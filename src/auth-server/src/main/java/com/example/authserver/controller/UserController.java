package com.example.authserver.controller;

import com.example.authserver.configure.S3Config;
import com.example.authserver.dto.request.ProfileRequest;
import com.example.authserver.dto.response.*;
import com.example.authserver.exception.CustomException;
import com.example.authserver.exception.CustomExceptionStatus;
import com.example.authserver.service.ResponseService;
import com.example.authserver.configure.security.authentication.CustomUserDetails;
import com.example.authserver.domain.type.RoleType;
import com.example.authserver.dto.*;
import com.example.authserver.dto.request.SignInRequest;
import com.example.authserver.service.UserService;
import com.example.authserver.util.ValidationExceptionProvider;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.Valid;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/auth-server")
public class UserController {

    private final UserService accountService;
    private final ResponseService responseService;
    private final S3Config s3Config;

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

    @GetMapping("/auth/info")
    public DataResponse<AccountAutoDto> getAuthAccount(@AuthenticationPrincipal CustomUserDetails customUserDetails) {
        return responseService.getDataResponse(accountService.getAuthAccount(customUserDetails));
    }

    @PostMapping("/send-mail")
    public DataResponse<MailResponse> sendEmail(@RequestParam(value = "email") String email) {
        return responseService.getDataResponse(accountService.sendEmail(email));
    }

    @GetMapping("/check-email")
    public CommonResponse checkEmail(@RequestParam(value = "key") String key) {
        accountService.checkEmail(key);

        return responseService.getSuccessResponse();
    }

    @PatchMapping("/auth/role")
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

    @PostMapping("/auth/find-id-list")
    public DataResponse<Map<Long, AccountInfoResponse>> findIdList(@RequestBody List<Long> requestAccountIds) {
        return responseService.getDataResponse(accountService.findIdList(requestAccountIds));
    }

    @PostMapping("/auth/profile")
    public CommonResponse uploadProfileImage(@AuthenticationPrincipal CustomUserDetails customUserDetails,
                                        @RequestParam("image") MultipartFile multipartFile) throws IOException {
        String upload = s3Config.upload(multipartFile);
        accountService.uploadProfile(customUserDetails.getAccount(), upload);
        return responseService.getSuccessResponse();
    }

    @PatchMapping("/auth/d/profile")
    public CommonResponse deleteProfileImage(@AuthenticationPrincipal CustomUserDetails customUserDetails) {

        accountService.deleteProfile(customUserDetails.getAccount());
        return responseService.getSuccessResponse();
    }

    @PatchMapping("/auth/profile")
    public CommonResponse modifyProfile(@AuthenticationPrincipal CustomUserDetails customUserDetails,
                                        @RequestBody @Valid ProfileRequest profileRequest, Errors errors) {
        if (errors.hasErrors()) ValidationExceptionProvider.throwValidError(errors);
        accountService.modifyProfile(customUserDetails.getAccount(),profileRequest);
        return responseService.getSuccessResponse();
    }

    @GetMapping("/name")
    public DataResponse<NameAndPhotoResponse> getNameAndPhotoById(@RequestParam(value = "id") Long id) {

        return responseService.getDataResponse(accountService.getNameAndPhoto(id));
    }

}
