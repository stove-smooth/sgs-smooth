package com.example.communityserver.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class MessageService {

    private static final String DEFAULT_RESPONSE = "Q";

    private static int num = 0;

    public String processMessage(String message) {

        // 상태관리 이벤트 처리
        log.info(message);

        return DEFAULT_RESPONSE;
    }
}
