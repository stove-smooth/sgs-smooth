package com.example.communityserver.domain;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import javax.persistence.*;

@Entity
@Table(name = "community_invitation")
@Getter
@Setter
@NoArgsConstructor
public class CommunityInvitation extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "community_invitation_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "community_id")
    private Community community;

    private Long userId;

    @Column(length = 10)
    private String code;

    private boolean activate;

    //== 연관관계 메서드 ==//
    public void setCommunity(Community community) {
        this.community = community;
        community.getInvitations().add(this);
    }

    //== 생성 메서드 ==//
//    public static CommunityInvitation createCommunityInvitation(
//            Community community,
//            Long userId
//    ) {
//        CommunityInvitation invitation = new CommunityInvitation();
//        invitation.setCommunity(community);
//        invitation.setUserId(userId);
//        return invitation;
//    }
}
