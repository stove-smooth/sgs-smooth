package com.example.communityserver.domain;

import com.example.communityserver.domain.type.ChannelStatus;
import com.example.communityserver.domain.type.ChannelType;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "channel")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Channel extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "channel_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private Category category;

    private Long userId;

    @Column(length = 200)
    private String name;

    @Column(length = 1024)
    private String description;

    @Enumerated(EnumType.STRING)
    private ChannelType type;

    private boolean isPublic;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "before_id")
    private Channel before;

    private LocalDateTime expiredAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id")
    private Channel parent;

    @OneToMany(mappedBy = "parent")
    private List<Channel> thread = new ArrayList<>();

    @OneToMany(mappedBy = "channel_member")
    private List<ChannelMember> members = new ArrayList<>();

    @Column(length = 10)
    @Enumerated(EnumType.STRING)
    private ChannelStatus status;
}
