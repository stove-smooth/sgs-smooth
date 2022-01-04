package com.example.roomserver.domain;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "room")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Room extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "room_id")
    private Long id;

    private Long hostId;

    @Column(length = 100)
    private String title;

    private String iconImage;

    @OneToMany(mappedBy = "room", cascade = CascadeType.ALL)
    private List<AccountRoom> accounts = new ArrayList<>();

    private Boolean isGroup;

    // 연관관계 메소드

    // 생성 메소드
    /**
     * public static Room createRoom(
     *             Long hostId,
     *             Long... accountId
     *     ) {
     *         Room room = new Room();
     *         return room;
     *     }
     */

    // 비즈니스 로직
}
