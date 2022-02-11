package com.example.communityserver.dto.response;

import com.example.communityserver.domain.RoomMember;
import com.example.communityserver.domain.type.UserState;
import com.example.communityserver.util.UserStateUtil;
import lombok.*;

import java.util.HashMap;
import java.util.Objects;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RoomMemberResponse {
    private Long id;
    private String nickname;
    private String image;
    private String code;
    private boolean owner;
    private String state;

    public static RoomMemberResponse fromEntity(RoomMember roomMember, HashMap<Long, UserResponse> userMap) {
        RoomMemberResponse response = new RoomMemberResponse();
        Long userId = roomMember.getUserId();
        UserResponse userResponse = userMap.get(userId);
        response.setId(userId);
        response.setNickname(userResponse.getName());
        response.setImage(userResponse.getImage());
        response.setCode(userResponse.getCode());
        response.setOwner(roomMember.isOwner());
        if (!Objects.isNull(UserStateUtil.status.get(userId)))
            response.setState(UserStateUtil.status.get(userId));
        else
            response.setState(UserState.OFFLINE);
        return response;
    }
}
