package com.example.communityserver.domain;

import com.example.communityserver.domain.type.ChannelStatus;
import com.example.communityserver.domain.type.ChannelType;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "channels")
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Channel extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "channel_id")
    private Long id;

    @JsonIgnore
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

    private Long before;

    private LocalDateTime expiredAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id")
    private Channel parent;

    @OneToMany(mappedBy = "parent")
    private List<Channel> thread = new ArrayList<>();

    @OneToMany(mappedBy = "channelMember", cascade = CascadeType.ALL)
    private List<ChannelMember> members = new ArrayList<>();

    @Column(length = 10)
    @Enumerated(EnumType.STRING)
    private ChannelStatus status;

    //== 연관관계 메서드 ==//
    public void setCategory(Category category) {
        this.category = category;
        category.getChannels().add(this);
    }

    public void addMember(ChannelMember channelMember) {
        members.add(channelMember);
        channelMember.setChannel(this);
    }

    //== 생성 메서드 ==//
    public static Channel createChannel(
            Category category,
            ChannelType type,
            String name,
            boolean isPublic,
            ChannelMember... members
    ) {
        Channel channel = new Channel();
        channel.setCategory(category);
        channel.setType(type);
        channel.setName(name);
        channel.setPublic(isPublic);
        if (!isPublic) {
            for (ChannelMember member: members) {
                channel.addMember(member);
            }
        }
        channel.setBefore(null);
        channel.setStatus(ChannelStatus.NORMAL);
        return channel;
    }
}
