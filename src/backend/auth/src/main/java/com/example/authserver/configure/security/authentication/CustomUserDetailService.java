package com.example.authserver.configure.security.authentication;

import com.example.authserver.domain.User;
import com.example.authserver.exception.CustomException;
import com.example.authserver.exception.CustomExceptionStatus;
import com.example.authserver.domain.type.Status;
import com.example.authserver.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CustomUserDetailService implements UserDetailsService {

    private final UserRepository accountRepository;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        Optional<User> account = accountRepository.findByEmailAndStatus(email, Status.VALID);
        if (!account.isPresent()) throw new CustomException(CustomExceptionStatus.ACCOUNT_NOT_FOUND);
        return new CustomUserDetails(account.get());
    }
}
