package com.example.communityserver.dto.response;

import com.example.communityserver.domain.Room;
import com.example.communityserver.domain.type.CommonStatus;
import lombok.*;

import java.util.List;
import java.util.stream.Collectors;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RoomDetailResponse {
    private Long id;
    private boolean group;
    private int count;
    private List<RoomMemberResponse> members;
    private String name;
    private String icon;

    public static RoomDetailResponse fromEntity(Room room) {
        RoomDetailResponse response = new RoomDetailResponse();
        response.setId(room.getId());
        response.setGroup(room.getIsGroup());
        response.setCount(
                room.getMembers().stream()
                        .filter(rm -> rm.getStatus().equals(CommonStatus.NORMAL))
                        .collect(Collectors.toList()).size());
        response.setName(room.getName());
        response.setIcon(room.getIconImage());
        return response;
    }
}
