package com.example.communityserver.dto.response;

import com.example.communityserver.domain.Room;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UnreceivedMessageRoomResponse {
    private Long id;
    private String name;
    private String icon;
    private int count;

    public static UnreceivedMessageRoomResponse fromEntity(Room room, int count) {
        UnreceivedMessageRoomResponse response = new UnreceivedMessageRoomResponse();
        response.setId(room.getId());
        response.setName(room.getName());
        response.setIcon(room.getIconImage());
        response.setCount(count);
        return response;
    }
}
