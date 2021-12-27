package com.example.authserver.repository;

import com.example.authserver.domain.Account;
import com.example.authserver.domain.Status;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface AccountRepository extends JpaRepository<Account,Long> {
    Optional<Account> findByEmailAndStatus(String email, Status valid);

}
