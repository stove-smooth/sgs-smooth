package com.example.roomserver.dto.response;

import com.example.roomserver.domain.Room;
import lombok.*;

import java.util.List;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class RoomListResponse {

    List<RoomInfo> rooms;

    @Getter
    @Setter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class RoomInfo {
        private Long roomId;
        private Long accountId;
        private String title;
        private String iconImage;
        private String state;
        private int count;
        private boolean isGroup;
    }
}
