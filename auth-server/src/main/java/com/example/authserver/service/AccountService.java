package com.example.authserver.service;

import com.example.authserver.configure.exception.CustomException;
import com.example.authserver.configure.exception.CustomExceptionStatus;
import com.example.authserver.configure.security.authentication.CustomUserDetails;
import com.example.authserver.configure.security.jwt.JwtTokenProvider;
import com.example.authserver.domain.Account;
import com.example.authserver.domain.BaseTimeEntity;
import com.example.authserver.domain.RoleType;
import com.example.authserver.dto.AccountAutoDto;
import com.example.authserver.dto.MailResponse;
import com.example.authserver.dto.SignInRequest;
import com.example.authserver.dto.SignInResponse;
import com.example.authserver.repository.AccountRepository;
import lombok.RequiredArgsConstructor;
import net.bytebuddy.utility.RandomString;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Random;
import java.util.concurrent.TimeUnit;

import static com.example.authserver.domain.Status.*;

@Transactional(readOnly = true)
@RequiredArgsConstructor
@Service
public class AccountService extends BaseTimeEntity {

    private long refreshTime = 14 * 24 * 60 * 60 * 1000L;

    private final AccountRepository accountRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;
    private final EmailService emailService;
    private final RedisTemplate<String, Object> redisTemplate;

    @Transactional
    public AccountAutoDto signUp(AccountAutoDto dto) {
        if (accountRepository.findByEmailAndStatus(dto.getEmail(), VALID).isPresent()) throw new CustomException(CustomExceptionStatus.DUPLICATED_EMAIL);

        dto.setPassword(passwordEncoder.encode(dto.getPassword()));
        Account account = Account.createAccount(dto);
        accountRepository.save(account);

        return dto;
    }

    @Transactional
    public SignInResponse signIn(SignInRequest request) {
        Account account = accountRepository.findByEmailAndStatus(request.getEmail(), VALID)
                .orElseThrow(() -> new CustomException(CustomExceptionStatus.FAILED_TO_LOGIN));
        if (!passwordEncoder.matches(request.getPassword(), account.getPassword())) {
            throw new CustomException(CustomExceptionStatus.FAILED_TO_LOGIN);
        }

        String refreshToken = jwtTokenProvider.CreateRefreshToken(account.getEmail());
        redisTemplate.opsForValue().set(account.getEmail(), refreshToken, refreshTime, TimeUnit.MILLISECONDS);


        SignInResponse res = SignInResponse.builder()
                .email(account.getEmail())
                .jwt(jwtTokenProvider.createToken(account.getEmail(),account.getRoleType()))
                .build();

        return res;
    }

    public AccountAutoDto getAuthAccount(CustomUserDetails customUserDetails) {
        Account account = customUserDetails.getAccount();

        return new AccountAutoDto(account);
    }

    @Transactional
    public MailResponse sendEmail(String email) {
        if (email == null) {
            throw new CustomException(CustomExceptionStatus.POST_USERS_EMPTY_EMAIL);
        }
        Random random = new Random();
        RandomString rs = new RandomString(6,random);
        redisTemplate.opsForValue().set(rs.toString(),email, 60*30L, TimeUnit.SECONDS);
        emailService.sendMail(email,"[ SGS-Smooth ] 회웝가입 인증이메일", "다음 인증코드를 입력해주세요: " + rs);

        MailResponse res = MailResponse.builder()
                .code(rs.toString()).build();

        return res;
    }

    @Transactional
    public void checkEmail(String key) {
        String email = (String) redisTemplate.opsForValue().get(key);
        accountRepository.findByEmailAndStatus(email,VALID).orElseThrow(() -> new CustomException(CustomExceptionStatus.ACCOUNT_NOT_FOUND));
        redisTemplate.delete(key);
    }

    @Transactional
    public void updateRole(String email, RoleType roleType) {
        Account account = accountRepository.findByEmailAndStatus(email, VALID)
                .orElseThrow(() -> new CustomException(CustomExceptionStatus.ACCOUNT_NOT_VALID));
        account.changeRole(roleType);
    }

    @Transactional
    public SignInResponse checkRefreshToken(String token, String refreshToken) {
        String email = jwtTokenProvider.getUsername(token);
        String refresh = (String) redisTemplate.opsForValue().get(email);

        if (refresh == null) {
            throw new CustomException(CustomExceptionStatus.INVALID_JWT);
        }
        if (!refresh.equals(refreshToken)) {
            throw new CustomException(CustomExceptionStatus.INVALID_JWT);
        }
        Account account = accountRepository.findByEmailAndStatus(email, VALID).orElseThrow(() -> new CustomException(CustomExceptionStatus.ACCOUNT_NOT_FOUND));

        SignInResponse res = SignInResponse.builder()
                .jwt(jwtTokenProvider.createToken(account.getEmail(),account.getRoleType()))
                .build();

        return res;
    }
}
