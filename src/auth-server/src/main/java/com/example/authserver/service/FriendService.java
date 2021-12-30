package com.example.authserver.service;

import com.example.authserver.configure.exception.CustomException;
import com.example.authserver.configure.exception.CustomExceptionStatus;
import com.example.authserver.configure.security.authentication.CustomUserDetails;
import com.example.authserver.domain.Account;
import com.example.authserver.domain.Friend;
import com.example.authserver.domain.tyoe.FriendState;
import com.example.authserver.dto.request.FriendRequest;
import com.example.authserver.dto.response.FriendResponse;
import com.example.authserver.dto.response.WaitingResponse;
import com.example.authserver.repository.AccountRepository;
import com.example.authserver.repository.FriendRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Transactional(readOnly = true)
@RequiredArgsConstructor
@Service
public class FriendService {

    private final AccountRepository accountRepository;
    private final FriendRepository friendRepository;

    @Transactional
    public void requestFriend(FriendRequest friendRequest, CustomUserDetails customUserDetails) {
        Account requestAccount = accountRepository.findByNameAndCode(friendRequest.getName(), friendRequest.getCode())
                .orElseThrow(() -> new CustomException(CustomExceptionStatus.ACCOUNT_NOT_FOUND));

        Account account = customUserDetails.getAccount();

        Friend friend = Friend.builder()
                .receiver(requestAccount)
                .sender(account)
                .friendState(FriendState.WAIT).build();

        friendRepository.save(friend);
    }

    @Transactional
    public WaitingResponse getFriendRequest(Long id) {
        Account account = accountRepository.findById(id).orElseThrow(() -> new CustomException(CustomExceptionStatus.ACCOUNT_NOT_FOUND));

        List<Friend> requestList = account.getRequestList();

        List<FriendResponse> toFriend = requestList.stream().map(
                f -> new FriendResponse(f.getId(), f.getReceiver().getName())
        ).collect(Collectors.toList());

        List<FriendResponse> toMe = requestList.stream().map(
                f -> new FriendResponse(f.getId(), f.getSender().getName())
        ).collect(Collectors.toList());

        WaitingResponse waitingResponse = WaitingResponse.builder()
                .toMe(toMe)
                .toFriend(toFriend).build();

        return waitingResponse;

    }

    @Transactional
    public void refuseFriend(Long id) {
        Friend friend = friendRepository.findById(id)
                .orElseThrow(() -> new CustomException(CustomExceptionStatus.FRIEND_NOT_FOUND));
        friendRepository.delete(friend);
    }
}