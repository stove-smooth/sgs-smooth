package com.example.communityserver.service;

import com.example.communityserver.util.UserStateUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import static com.example.communityserver.domain.type.UserState.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class MessageService {

    private static final String DEFAULT_RESPONSE = "Q";
    private static final String SEP = ",";

    // 상태관리 서버에서 유저 로그인/로그아웃 이벤트 발생 시 메세지 수신
    public String processMessage(String message) {
        log.info("PRESENCE UPDATE BY TCP : {}", message);
        try {
            String[] userState = message.split(SEP);
            Long userId = Long.parseLong(userState[0]);
            String state = userState[1].equals(ONLINE) ? ONLINE : OFFLINE;
            UserStateUtil.status.put(userId, state);
        } catch (Exception e) {
            log.error("PRESENCE UPDATE BY TCP ERROR");
        } finally {
            return DEFAULT_RESPONSE;
        }
    }
}
