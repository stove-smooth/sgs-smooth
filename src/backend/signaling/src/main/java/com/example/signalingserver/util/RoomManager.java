package com.example.signalingserver.util;

import lombok.RequiredArgsConstructor;
import org.kurento.client.KurentoClient;
import org.springframework.stereotype.Component;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

@Component
@RequiredArgsConstructor
public class RoomManager {

    private final KurentoClient kurento;
    private final ConcurrentMap<String, Room> rooms = new ConcurrentHashMap<>();

    public Room getRoom(String roomId) {
        Room room = rooms.get(roomId);
        if (room == null) {
            room = new Room(roomId, kurento.createMediaPipeline());
            rooms.put(roomId, room);
        }
        return room;
    }

    public void removeRoom(Room room) {
        this.rooms.remove(room.getRoomId());

        room.close();
    }

//    public MediaPipeline getMediaPipeLine(String pipelineId) {
//        return kurento.getServerManager().getPipelines().stream()
//                .filter(p -> p.getId().equals(pipelineId))
//                .findAny().orElse(kurento.createMediaPipeline());
//    }
}
