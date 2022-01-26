package com.example.signalingserver.service;

import com.example.signalingserver.dto.request.JoinRequest;
import com.example.signalingserver.domain.Room;
import com.example.signalingserver.dto.response.ExistingParticipantsResponse;
import com.example.signalingserver.dto.response.ParticipantArrivedResponse;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.kurento.client.KurentoClient;
import org.kurento.client.MediaPipeline;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.SetOperations;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.TimeUnit;

@Slf4j
@Service
@RequiredArgsConstructor
public class RoomService {

    private final RedisTemplate redisTemplate;
    private final ValueOperations<String, String> valueOperations = redisTemplate.opsForValue();
    private final SetOperations<String, String> setOperations = redisTemplate.opsForSet();
    private final ObjectMapper objectMapper;
    private final KurentoClient kurento;

    private static final String USER = "user_";
    private static final String CHANNEL = "channel_";
    private static final String DM = "dm_";
    private static final String PIPELINE = "_pipeline";
    private static final String SEP = "-";
    private static final long TIME = 24 * 60 * 60 * 1000L;

    /**
     * key                              value
     * channel_{channelId}              채널에 속한 유저들의 id 리스트
     * dm_{dmId}                        DM에 속한 유저들의 id 리스트
     * channel_{channelId}_pipeline     {channelId}의 파이프라인 아이디
     * dm_{dmId}_pipeline               {dmId}의 파이프라인 아이디
     */

    public ParticipantArrivedResponse newParticipantArrived(JoinRequest request) {
        return new ParticipantArrivedResponse(request.getUserId(), request.getSource());
    }

    public ExistingParticipantsResponse join(JoinRequest request, boolean isChannel) {

        String key = isChannel ? CHANNEL : DM;
        key += request.getId();

        String userSource = request.getUserId() + SEP + request.getSource();

        String pipelineId = valueOperations.get(key+PIPELINE);
        if (Objects.isNull(pipelineId)) {
            // 방 없는 경우 미디어 파이프라인 생성
            MediaPipeline newPipeline = kurento.createMediaPipeline();
            redisTemplate.opsForValue().set(key+PIPELINE, newPipeline, TIME, TimeUnit.MILLISECONDS);
        }

        // 유저 추가
        setOperations.add(key, userSource);
        Set<String> participantsSet = setOperations.members(key);
        ExistingParticipantsResponse existingParticipants =
                new ExistingParticipantsResponse(new ArrayList<>(participantsSet));

        return existingParticipants;
    }
}
