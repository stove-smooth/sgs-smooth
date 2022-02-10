package com.example.communityserver.util;

import com.example.communityserver.client.PresenceClient;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserStateUtil {

    public static ConcurrentMap<Long, String> status = new ConcurrentHashMap<>();

    // 무결성을 위해 사용자 상태 정보 풀 쿼리 진행할 주기 : 6시간
    private final static int FULL_QUERY_INTERVAL = 1000 * 60 * 60 * 6;

    private final PresenceClient presenceClient;

    @Scheduled(fixedDelay = FULL_QUERY_INTERVAL)
    public void updateAllUserState() {
        log.info("UPDATE USER STATE");
        // 상태관리 서버에서 접속한 모든 유저 정보 조회
        ConcurrentMap<Long, String> presenceState = presenceClient.getUserState();

        // status 바꿔주기
        try {
            status = presenceState;
        } catch (Exception e) {
            // 에러 발생 시 기존 state 유지
            log.error("PRESENCE SERVER ERROR");
        }
    }
}
