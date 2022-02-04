package com.example.communityserver.dto.response;

import com.example.communityserver.domain.Room;
import com.example.communityserver.domain.RoomMember;
import com.example.communityserver.domain.type.CommonStatus;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RoomResponse {
    private Long id;
    private boolean group;
    private List<Long> members;
    private int count;
    private String name;
    private String icon;
    private String state;
    private LocalDateTime createdAt;

    public static RoomResponse fromEntity(Room room) {
        RoomResponse roomResponse = new RoomResponse();
        roomResponse.setId(room.getId());
        roomResponse.setGroup(room.getIsGroup());
        roomResponse.setMembers(
                room.getMembers().stream()
                        .filter(rm -> rm.getStatus().equals(CommonStatus.NORMAL))
                        .map(RoomMember::getUserId)
                        .collect(Collectors.toList()));
        roomResponse.setCount(
                room.getMembers().stream()
                        .filter(rm -> rm.getStatus().equals(CommonStatus.NORMAL))
                        .collect(Collectors.toList()).size());
        roomResponse.setName(room.getName());
        roomResponse.setIcon(room.getIconImage());
        roomResponse.setCreatedAt(room.getCreatedAt());
        return roomResponse;
    }
}
