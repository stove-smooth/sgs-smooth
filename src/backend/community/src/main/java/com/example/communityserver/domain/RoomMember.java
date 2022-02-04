package com.example.communityserver.domain;

import com.example.communityserver.domain.type.CommonStatus;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Table(name = "room_member")
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class RoomMember extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "room_member_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "room_id")
    private Room room;

    private Long userId;

    private boolean owner;

    @Enumerated(EnumType.STRING)
    private CommonStatus status;

    //== 생성 메서드 ==//
    public static RoomMember createRoomMember(
        Long userId,
        boolean owner
    ) {
        RoomMember roomMember = new RoomMember();
        roomMember.setUserId(userId);
        roomMember.setOwner(owner);
        return roomMember;
    }

    public void delete() {
        this.setStatus(CommonStatus.DELETED);
    }
}
