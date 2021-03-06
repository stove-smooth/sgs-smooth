package com.example.authserver.service;

import com.example.authserver.dto.request.ProfileRequest;
import com.example.authserver.dto.response.*;
import com.example.authserver.exception.CustomException;
import com.example.authserver.exception.CustomExceptionStatus;
import com.example.authserver.configure.security.authentication.CustomUserDetails;
import com.example.authserver.configure.security.jwt.JwtTokenProvider;
import com.example.authserver.domain.*;
import com.example.authserver.domain.type.RoleType;
import com.example.authserver.dto.*;
import com.example.authserver.dto.request.SignInRequest;
import com.example.authserver.repository.DeviceRepository;
import com.example.authserver.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.TimeUnit;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.example.authserver.domain.type.Status.*;

@Slf4j
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Service
public class UserService extends BaseTimeEntity {

    private long refreshTime = 14 * 24 * 60 * 60 * 1000L;

    private final UserRepository accountRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;
    private final EmailService emailService;
    private final RedisTemplate<String, Object> redisTemplate;
    private final DeviceRepository deviceRepository;

    @Transactional
    public AccountAutoDto signUp(AccountAutoDto dto) {
        if (accountRepository.findByEmailAndStatus(dto.getEmail(), VALID).isPresent()) throw new CustomException(CustomExceptionStatus.DUPLICATED_EMAIL);

        dto.setPassword(passwordEncoder.encode(dto.getPassword()));
        User account = User.createAccount(dto);
        User save = accountRepository.save(account);

        Device device = Device.builder()
                .user(account)
                .last_access(LocalDateTime.now()).build();
        deviceRepository.save(device);
        dto.setId(save.getId());

        return dto;
    }

    @Transactional
    public SignInResponse signIn(SignInRequest request) {
        User account = accountRepository.findByEmailAndStatus(request.getEmail(), VALID)
                .orElseThrow(() -> new CustomException(CustomExceptionStatus.FAILED_TO_LOGIN));
        if (!passwordEncoder.matches(request.getPassword(), account.getPassword())) {
            throw new CustomException(CustomExceptionStatus.FAILED_TO_LOGIN);
        }

        String refreshToken = jwtTokenProvider.CreateRefreshToken(account.getEmail());
        redisTemplate.opsForValue().set(account.getEmail(), refreshToken, refreshTime, TimeUnit.MILLISECONDS);

        Device device = deviceRepository.findByUserId(account.getId());
        device.setToken(request.getDeviceToken());
        device.setType(request.getType());

        String url = setURL();

        SignInResponse res = SignInResponse.builder()
                .id(account.getId())
                .name(account.getName())
                .code(account.getCode())
                .email(account.getEmail())
                .accessToken(jwtTokenProvider.createToken(account.getEmail(),account.getRoleType(),account.getId()))
                .refreshToken(refreshToken)
                .deviceToken(device.getToken())
                .type(device.getType())
                .url(url)
                .build();

        return res;
    }

    @Transactional
    public AccountAutoDto getAuthAccount(CustomUserDetails customUserDetails) {
        User account = customUserDetails.getAccount();

        return new AccountAutoDto(account);
    }

    @Transactional
    public MailResponse sendEmail(String email) {
        User exist = accountRepository.findByEmail(email);
        if (exist != null) {
            throw new CustomException(CustomExceptionStatus.DUPLICATED_EMAIL);
        }

        if (email == null) {
            throw new CustomException(CustomExceptionStatus.POST_USERS_EMPTY_EMAIL);
        }
        int leftLimit = 48; // numeral '0'
        int rightLimit = 122; // letter 'z'
        int targetStringLength = 6;
        Random random = new Random();

        String generatedString = random.ints(leftLimit, rightLimit + 1)
                .filter(i -> (i <= 57 || i >= 65) && (i <= 90 || i >= 97))
                .limit(targetStringLength)
                .collect(StringBuilder::new, StringBuilder::appendCodePoint, StringBuilder::append)
                .toString();
        redisTemplate.opsForValue().set(generatedString,email, 60*30L, TimeUnit.SECONDS);
        emailService.sendMail(email,"[ SGS-Smooth ] ???????????? ???????????????", "?????? ??????????????? ??????????????????: " + generatedString);

        MailResponse res = MailResponse.builder()
                .code(generatedString).build();

        return res;
    }

    @Transactional
    public void checkEmail(String key) {
        String email = (String) redisTemplate.opsForValue().get(key);
        if (email == null) {
            throw new CustomException(CustomExceptionStatus.NOT_VALID_CODE);
        } else {
            redisTemplate.delete(key);
        }
    }

    @Transactional
    public void updateRole(String email, RoleType roleType) {
        User account = accountRepository.findByEmailAndStatus(email, VALID)
                .orElseThrow(() -> new CustomException(CustomExceptionStatus.ACCOUNT_NOT_VALID));
        account.changeRole(roleType);
    }

    @Transactional
    public SignInResponse checkRefreshToken(String token, String refreshToken,String url) {
        String email = jwtTokenProvider.getUsername(token);
        String refresh = (String) redisTemplate.opsForValue().get(email);

        if (refresh == null) {
            throw new CustomException(CustomExceptionStatus.INVALID_JWT);
        }
        if (!refresh.equals(refreshToken)) {
            throw new CustomException(CustomExceptionStatus.INVALID_JWT);
        }
        User account = accountRepository.findByEmailAndStatus(email, VALID).orElseThrow(() -> new CustomException(CustomExceptionStatus.ACCOUNT_NOT_FOUND));

        String count = String.valueOf(redisTemplate.opsForValue().get(url));
        redisTemplate.opsForValue().set(url,Integer.parseInt(count) -1,refreshTime, TimeUnit.MILLISECONDS);

        String newUrl = setURL();
        SignInResponse res = SignInResponse.builder()
                .accessToken(jwtTokenProvider.createToken(account.getEmail(),account.getRoleType(),account.getId()))
                .refreshToken(refreshToken)
                .url(newUrl)
                .build();

        return res;
    }

    public Map<Long,AccountInfoResponse> findIdList(List<Long> requestAccountIds) {
        List<User> accountList = accountRepository.findById(requestAccountIds);

        List<AccountInfoResponse> collect = accountList.stream().map(
                a -> new AccountInfoResponse(a.getId(), a.getName(), a.getCode(), a.getProfileImage(), a.getState().getName())
        ).collect(Collectors.toList());

        Map<Long,AccountInfoResponse> map = collect.stream()
                .collect(Collectors.toMap(AccountInfoResponse::getId, Function.identity()));

        return map;
    }

    @Transactional
    public void uploadProfile(User account, String upload) {
        account.changeProfileImage(upload);
        accountRepository.save(account);
    }

    @Transactional
    public void deleteProfile(User account) {
        account.changeProfileImage(null);
        accountRepository.save(account);
    }

    @Transactional
    public void modifyProfile(User account, ProfileRequest profileRequest) {
        account.changeBio(profileRequest.getBio());
        accountRepository.save(account);
    }

    public NameAndPhotoResponse getNameAndPhoto(Long id) {
        User user = accountRepository.findById(id)
                .orElseThrow(() -> new CustomException(CustomExceptionStatus.ACCOUNT_NOT_FOUND));

        NameAndPhotoResponse result = NameAndPhotoResponse.builder()
                .name(user.getName())
                .code(user.getCode())
                .bio(user.getBio())
                .profileImage(user.getProfileImage()).build();

        return result;
    }

    @Transactional
    public Map<Long,DeviceResponse> getDeviceToken(List<Long> id) {
        Map<Long,DeviceResponse> result = new HashMap<>();
        List<Device> device = deviceRepository.findByUserId(id);
        for (Device d : device) {
            DeviceResponse deviceResponse = DeviceResponse.builder()
                    .type(d.getType())
                    .token(d.getToken()).build();
            result.put(d.getUser().getId(),deviceResponse);
        }

        return result;
    }

    public String setURL() {
        String chat1 = String.valueOf(redisTemplate.opsForValue().get("https://c1.yoloyolo.org"));
        String chat2 = String.valueOf(redisTemplate.opsForValue().get("https://c2.yoloyolo.org"));
        String chat3 = String.valueOf(redisTemplate.opsForValue().get("https://c3.yoloyolo.org"));

        if (chat1.equals("null")) {
            redisTemplate.opsForValue().set("https://c1.yoloyolo.org",0,14,TimeUnit.DAYS);
        }
        if (chat2.equals("null")) {
            redisTemplate.opsForValue().set("https://c2.yoloyolo.org",0,14,TimeUnit.DAYS);
        }
        if (chat3.equals("null")) {
            redisTemplate.opsForValue().set("https://c3.yoloyolo.org",0,14,TimeUnit.DAYS);
        }

        int c1 = chat1.equals("null") ? 0 : Integer.parseInt(chat1);
        int c2 = chat1.equals("null") ? 0 : Integer.parseInt(chat2);
        int c3 = chat1.equals("null") ? 0 : Integer.parseInt(chat3);

        int value = (c2 >= c1) && (c3 >= c1) ? c1 : (c2 >= c3 ? c3 : c2);
        if (c1 == value) {
            redisTemplate.opsForValue().set("https://c1.yoloyolo.org",value+1,14,TimeUnit.DAYS);
            return "https://c1.yoloyolo.org";
        } else if (c2 == value) {
            redisTemplate.opsForValue().set("https://c2.yoloyolo.org",value+1,14,TimeUnit.DAYS);
            return "https://c2.yoloyolo.org";
        } else {
            redisTemplate.opsForValue().set("https://c3.yoloyolo.org",value+1,14,TimeUnit.DAYS);
            return "https://c3.yoloyolo.org";
        }
    }
}
