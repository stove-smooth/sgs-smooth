package com.example.authserver.repository;

import com.example.authserver.domain.Account;
import com.example.authserver.domain.type.Status;
import io.lettuce.core.dynamic.annotation.Param;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface AccountRepository extends JpaRepository<Account,Long> {
    Optional<Account> findByEmailAndStatus(String email, Status valid);
    Optional<Account> findByNameAndCode(String name, String code);

    @Query(nativeQuery = true,value = "SELECT * FROM account as a WHERE a.account_id in (:ids)")
    List<Account> findById(@Param("ids") List<Long> ids);


}
