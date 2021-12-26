package com.example.authserver.service;

import com.example.authserver.configure.exception.CustomException;
import com.example.authserver.configure.exception.CustomExceptionStatus;
import com.example.authserver.configure.security.authentication.CustomUserDetails;
import com.example.authserver.configure.security.jwt.JwtTokenProvider;
import com.example.authserver.domain.Account;
import com.example.authserver.domain.BaseTimeEntity;
import com.example.authserver.dto.AccountAutoDto;
import com.example.authserver.dto.SignInRequest;
import com.example.authserver.dto.SignInResponse;
import com.example.authserver.repository.AccountRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import static com.example.authserver.domain.Status.*;

@Transactional(readOnly = true)
@RequiredArgsConstructor
@Service
public class AccountService extends BaseTimeEntity {

    private final AccountRepository accountRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;

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
}
