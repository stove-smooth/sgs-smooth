package com.example.communityserver.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/community-server/channel")
public class ChannelController {

    /**
     * 1. 채널 생성하기
     * 2. 채널 이름 수정하기
     * 3. 채널 소개 편집하기
     * 4. 카테고리 배치 순서 바꾸기
     * 5. 채널 삭제하기
     * 6. 채널에 초대하기
     * 7. 채널에서 추방하기
     * 8. 채널 복제하기
     * 7. 카테고리 내 메세지 읽음 처리 (Optional)
     */
}
