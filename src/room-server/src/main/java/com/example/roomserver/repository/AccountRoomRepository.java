package com.example.roomserver.repository;

import com.example.roomserver.domain.AccountRoom;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AccountRoomRepository extends JpaRepository<AccountRoom, Long> {
    List<AccountRoom> findByAccountId(Long accountId);
}
