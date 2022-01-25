package com.example.communityserver.domain;

import com.example.communityserver.domain.type.CommonStatus;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "room")
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Room extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "room_id")
    private Long id;

    @Column(length = 100)
    private String name;

    private String iconImage;

    @OneToMany(mappedBy = "room", cascade = CascadeType.ALL)
    private List<RoomMember> members = new ArrayList<>();

    private Boolean isGroup;

    @Enumerated(EnumType.STRING)
    private CommonStatus status;

    //== 생성 메소드 ==//
    public static Room createRoom(
            String name,
            List<RoomMember> members
    ) {
        Room room = new Room();
        room.setName(name);
        for (RoomMember member: members)
            room.addMember(member);
        room.setIsGroup(members.size() > 2 ? true : false);
        room.setStatus(CommonStatus.NORMAL);
        return room;
    }

    public void addMember(RoomMember roomMember) {
        this.getMembers().add(roomMember);
        roomMember.setRoom(this);
    }
}
