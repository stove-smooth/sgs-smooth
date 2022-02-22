package com.example.communityserver.domain;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "room_invitation")
@Getter
@Setter
@NoArgsConstructor
public class RoomInvitation extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "room_invitation_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "room_id")
    private Room room;

    @Column(length = 10)
    private String code;

    private LocalDateTime expiredAt;

    //== 연관관계 메서드 ==//
    public void setRoom(Room room) {
        this.room = room;
        room.getInvitations().add(this);
    }
}
