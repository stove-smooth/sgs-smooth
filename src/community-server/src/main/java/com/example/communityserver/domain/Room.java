package com.example.communityserver.domain;

import com.example.communityserver.domain.type.CommonStatus;
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

    @Column(length = 100)
    private String name;

    private String iconImage;

    @OneToMany(mappedBy = "room", cascade = CascadeType.ALL)
    private List<RoomMember> members = new ArrayList<>();

    private Boolean isGroup;

    @Enumerated(EnumType.STRING)
    private CommonStatus status;
}
