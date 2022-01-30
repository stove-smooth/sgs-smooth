package com.example.authserver.service;

import com.example.authserver.domain.User;
import com.example.authserver.exception.CustomException;
import com.example.authserver.exception.CustomExceptionStatus;
import com.example.authserver.configure.security.authentication.CustomUserDetails;
import com.example.authserver.domain.Friend;
import com.example.authserver.domain.type.FriendState;
import com.example.authserver.dto.request.FriendRequest;
import com.example.authserver.dto.response.FriendResponse;
import com.example.authserver.dto.response.WaitingResponse;
import com.example.authserver.repository.UserRepository;
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

    private final UserRepository accountRepository;
    private final FriendRepository friendRepository;

    @Transactional
    public void requestFriend(FriendRequest friendRequest, CustomUserDetails customUserDetails) {
        User requestAccount = accountRepository.findByNameAndCode(friendRequest.getName(), friendRequest.getCode())
                .orElseThrow(() -> new CustomException(CustomExceptionStatus.ACCOUNT_NOT_FOUND));

        User account = customUserDetails.getAccount();

        Friend friend = Friend.builder()
                .receiver(requestAccount)
                .sender(account)
                .friendState(FriendState.REQUEST).build();

        friendRepository.save(friend);
    }

    @Transactional
    public List<FriendResponse> getFriendRequest(Long id) {
        User account = accountRepository.findById(id).orElseThrow(() -> new CustomException(CustomExceptionStatus.ACCOUNT_NOT_FOUND));

        List<Friend> responseList = account.getResponseList();
        List<Friend> requestList = account.getRequestList();

        List<FriendResponse> result = responseList.stream()
                .map(
                f -> convertRequestFriend(f)
        ).collect(Collectors.toList());

        List<FriendResponse> sendToFriend = requestList.stream()
                .filter(f -> !f.getFriendState().equals(FriendState.BAN))
                .map(f -> convertResponseFriend(f)).collect(Collectors.toList());

        result.addAll(sendToFriend);

        return result;

    }

    private FriendResponse convertRequestFriend(Friend friend) {
        FriendResponse response = FriendResponse.builder()
                .id(friend.getId())
                .userId(friend.getSender().getId())
                .name(friend.getSender().getName())
                .code(friend.getSender().getCode())
                .profileImage(friend.getSender().getProfileImage())
                .state(friend.getFriendState().toString().equals("REQUEST") ? "WAIT" : friend.getFriendState().toString()).build();

        return response;
    }

    private FriendResponse convertResponseFriend(Friend friend) {
        FriendResponse response = FriendResponse.builder()
                .id(friend.getId())
                .userId(friend.getReceiver().getId())
                .name(friend.getReceiver().getName())
                .code(friend.getReceiver().getCode())
                .profileImage(friend.getReceiver().getProfileImage())
                .state(friend.getFriendState().toString()).build();

        return response;
    }

    @Transactional
    public void refuseFriend(Long id) {
        Friend friend = friendRepository.findById(id)
                .orElseThrow(() -> new CustomException(CustomExceptionStatus.FRIEND_NOT_FOUND));
        friendRepository.delete(friend);
    }

    @Transactional
    public void addToFriend(Long id) {
        Friend friend = friendRepository.findById(id)
                .orElseThrow(() -> new CustomException(CustomExceptionStatus.FRIEND_NOT_FOUND));
        friend.changeFriendState(FriendState.ACCEPT);
    }

    @Transactional
    public void banFriend(Long id) {
        Friend friend = friendRepository.findById(id)
                .orElseThrow(() -> new CustomException(CustomExceptionStatus.FRIEND_NOT_FOUND));
        friend.changeFriendState(FriendState.BAN);
    }
}
