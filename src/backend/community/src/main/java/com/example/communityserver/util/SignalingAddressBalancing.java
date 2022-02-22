package com.example.communityserver.util;

import com.example.communityserver.domain.type.ChannelStatus;
import com.example.communityserver.domain.type.ChannelType;
import com.example.communityserver.domain.type.CommonStatus;
import com.example.communityserver.dto.response.AddressResponse;
import com.example.communityserver.exception.CustomException;
import com.example.communityserver.repository.ChannelRepository;
import com.example.communityserver.repository.RoomRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.SetOperations;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

import static com.example.communityserver.exception.CustomExceptionStatus.*;

@Component
@RequiredArgsConstructor
public class SignalingAddressBalancing {

    private final RedisTemplate redisTemplate;
    private final ChannelRepository channelRepository;
    private final RoomRepository roomRepository;

    public AddressResponse getConnectAddress(Long channelId, boolean isChannel) {
        isValidId(channelId, isChannel);
        return new AddressResponse(getInstance(channelId));
    }

    private void isValidId(Long id, boolean isChannel) {
        if (isChannel) {
            channelRepository.findById(id)
                    .filter(c -> c.getStatus().equals(ChannelStatus.NORMAL))
                    .filter(c -> c.getType().equals(ChannelType.VOICE))
                    .orElseThrow(() -> new CustomException(NON_VALID_CHANNEL));
        } else {
            roomRepository.findById(id)
                    .filter(r -> r.getStatus().equals(CommonStatus.NORMAL))
                    .orElseThrow(() -> new CustomException(NON_VALID_ROOM));
        }
    }

    private String getInstance(Long channelId) {
        List<String> keys = (List<String>) redisTemplate.keys("*").stream()
                       .filter(k -> String.valueOf(k).contains("server"))
                       .collect(Collectors.toList());

        if (keys.size() == 0) {
            throw new CustomException(EMPTY_REGISTERED_SERVER);
        }

        SetOperations<String, String> setOperations = redisTemplate.opsForSet();
        String leastUsedInstance = keys.get(0);
        int min = -1;
        for (String key : keys) {
           if (setOperations.members(key).contains("c" + channelId))
               return key.split("-")[1];
           if (min < setOperations.members(key).size()) {
               leastUsedInstance = key;
               min = setOperations.members(key).size();
           }
        }
        return leastUsedInstance.split("-")[1];
    }
}
