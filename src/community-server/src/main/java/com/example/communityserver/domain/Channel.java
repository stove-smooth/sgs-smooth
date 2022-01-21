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
import java.util.Objects;

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

    private String username;

    @Column(length = 200)
    private String name;

    @Column(length = 1024)
    private String description;

    @Enumerated(EnumType.STRING)
    private ChannelType type;

    private boolean isPublic;

    @OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private Channel beforeNode;

    @OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private Channel nextNode;

    private LocalDateTime expiredAt;

    private Long messageId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id")
    private Channel parent;

    @OneToMany(mappedBy = "parent")
    private List<Channel> thread = new ArrayList<>();

    @OneToMany(mappedBy = "channel", cascade = CascadeType.ALL)
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

    public void setNextNode(Channel nextNode) {
        this.nextNode = nextNode;
        if (!Objects.isNull(nextNode))
            nextNode.setBeforeNode(this);
    }

    public void setParent(Channel parent) {
        this.parent = parent;
        parent.getThread().add(this);
    }

    //== 생성 메서드 ==//
    public static Channel createChannel(
            Category category,
            ChannelType type,
            String name,
            boolean isPublic,
            Channel nextNode,
            List<ChannelMember> channelMembers
    ) {
        Channel channel = new Channel();
        channel.setUsername(null);
        channel.setCategory(category);
        channel.setType(type);
        channel.setName(name);
        channel.setPublic(isPublic);
        if (!isPublic) {
            for (ChannelMember member: channelMembers) {
                channel.addMember(member);
            }
        }
        channel.setNextNode(nextNode);
        channel.setStatus(ChannelStatus.NORMAL);
        return channel;
    }

    public static Channel createThread(
            String username,
            Long messageId,
            Channel parent,
            String name,
            List<ChannelMember> channelMembers
    ) {
        Channel thread = new Channel();
        thread.setUsername(username);
        thread.setMessageId(messageId);
        thread.setParent(parent);
        thread.setName(name);
        thread.setType(ChannelType.TEXT);
        thread.setPublic(parent.isPublic());
        thread.setMembers(channelMembers);
        thread.setExpiredAt(LocalDateTime.now().plusHours(24));
        thread.setStatus(ChannelStatus.NORMAL);
        return thread;
    }

    public void locate(Channel tobe, Channel first) {
        this.beforeNode.setNextNode(this.nextNode);
        if (Objects.isNull(tobe)) {
            this.setBeforeNode(null);
            this.setNextNode(first);
        } else {
            this.setNextNode(tobe.getNextNode());
            tobe.setNextNode(this);
        }
    }

    public void delete() {
        if (Objects.isNull(this.beforeNode)) {
            if (!Objects.isNull(this.nextNode)) {
                this.nextNode.setBeforeNode(null);
            }
        } else {
            this.beforeNode.setNextNode(this.nextNode);
        }
        this.setStatus(ChannelStatus.DELETED);
    }
}
