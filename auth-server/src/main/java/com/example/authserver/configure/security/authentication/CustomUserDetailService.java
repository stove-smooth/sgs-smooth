package com.example.authserver.configure.security.authentication;

import com.example.authserver.configure.exception.CustomException;
import com.example.authserver.configure.exception.CustomExceptionStatus;
import com.example.authserver.domain.Account;
import com.example.authserver.domain.Status;
import com.example.authserver.repository.AccountRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CustomUserDetailService implements UserDetailsService {

    private final AccountRepository accountRepository;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        Optional<Account> account = accountRepository.findByEmailAndStatus(email, Status.VALID);
        if (!account.isPresent()) throw new CustomException(CustomExceptionStatus.ACCOUNT_NOT_FOUND);
        return new CustomUserDetails(account.get());
    }
}
