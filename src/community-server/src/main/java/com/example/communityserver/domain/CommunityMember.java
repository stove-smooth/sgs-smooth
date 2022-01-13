package com.example.communityserver.domain;

import com.example.communityserver.domain.type.CommunityMemberStatus;
import com.example.communityserver.domain.type.CommunityRole;
import com.fasterxml.jackson.annotation.JsonIgnore;
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

    @Column(columnDefinition = "TINYINT(1) DEFAULT TRUE")
    private boolean isFirstNode;

    @OneToOne(fetch = FetchType.LAZY)
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
            nextNode.isFirstNode = false;
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
        communityMember.setFirstNode(true);
        communityMember.setNextNode(nextNode);
        communityMember.setStatus(CommunityMemberStatus.NORMAL);
        return communityMember;
    }

    //== 비즈니스 메서드 ==//
    public void locate(CommunityMember before, CommunityMember first) {
        CommunityMember originBeforeNode = first;
        while(!Objects.isNull(originBeforeNode.getNextNode())) {
            if (originBeforeNode.getNextNode().equals(this))
                break;
            else
                originBeforeNode = originBeforeNode.getNextNode();
        }
        if (Objects.isNull(before)) {
            this.isFirstNode = true;
            originBeforeNode.setNextNode(this.nextNode);
            this.nextNode = first;
            first.setFirstNode(false);
        } else {
            CommunityMember originNextNode = before.getNextNode();
            before.setNextNode(this);
            if (!Objects.isNull(originNextNode))
                originNextNode.setNextNode(this.nextNode);
            this.nextNode = originNextNode;
            originBeforeNode.setNextNode(before);
        }
    }
}
