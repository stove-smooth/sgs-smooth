package com.example.communityserver.domain;

import com.example.communityserver.domain.type.CommunityMemberStatus;
import com.example.communityserver.domain.type.CommunityRole;
import lombok.*;

import javax.persistence.*;
import java.util.Objects;

@Entity
@Table(name = "community_member")
@Getter @Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class CommunityMember extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "community_member_id")
    private Long id;

    private Long userId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "community_id")
    private Community community;

    @Column(length = 200)
    private String nickname;

    private String profileImage;

    @Column(length = 256)
    private String memo;

    @Column(length = 10)
    @Enumerated(EnumType.STRING)
    private CommunityRole role;

    @OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private CommunityMember beforeNode;

    @OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private CommunityMember nextNode;

    @Column(length = 10)
    @Enumerated(EnumType.STRING)
    private CommunityMemberStatus status;

    //== 연관관계 메서드 ==//
    public void setCommunity(Community community) {
        this.community = community;
        community.getMembers().add(this);
    }

    public void setNextNode(CommunityMember nextNode) {
        this.nextNode = nextNode;
        if (!Objects.isNull(nextNode))
            nextNode.setBeforeNode(this);
    }

    //== 생성 메서드 ==//
    public static CommunityMember createCommunityMember(
            Long userId,
            Community community,
            String nickname,
            String profileImage,
            CommunityMember nextNode,
            CommunityRole role
    ) {
        CommunityMember communityMember = new CommunityMember();
        communityMember.setUserId(userId);
        communityMember.setCommunity(community);
        communityMember.setNickname(nickname);
        communityMember.setProfileImage(profileImage);
        communityMember.setMemo(null);
        communityMember.setRole(role);
        communityMember.setNextNode(nextNode);
        communityMember.setStatus(CommunityMemberStatus.NORMAL);
        return communityMember;
    }

    //== 비즈니스 메서드 ==//
    public void locate(CommunityMember tobe, CommunityMember first) {
        if (Objects.isNull(this.beforeNode)) {
            this.nextNode.setBeforeNode(null);
            this.setNextNode(tobe.getNextNode());
            tobe.setNextNode(this);
        } else {
            this.beforeNode.setNextNode(this.nextNode);
            if (Objects.isNull(tobe)) {
                this.setBeforeNode(null);
                this.setNextNode(first);
            } else {
                this.setNextNode(tobe.getNextNode());
                tobe.setNextNode(this);
            }
        }
    }

    public void delete() {
        deleteInList();
        this.setStatus(CommunityMemberStatus.DELETED);
    }

    public void suspend() {
        deleteInList();
        this.setStatus(CommunityMemberStatus.SUSPENDED);
    }

    // 노드 연결 관리용
    private void deleteInList() {
        if (Objects.isNull(this.beforeNode)) {
            if (!Objects.isNull(this.nextNode)) {
                this.nextNode.setBeforeNode(null);
            }
        } else {
            this.beforeNode.setNextNode(this.nextNode);
        }
    }
}
