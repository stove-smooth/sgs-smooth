package com.example.communityserver.domain;

import com.example.communityserver.domain.type.CommunityMapperStatus;
import com.example.communityserver.domain.type.CommunityRole;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Table(name = "community_mapper")
@Getter @Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class CommunityMapper extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "community_mapper_id")
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

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "before_id")
    private CommunityMapper before;

    @Column(length = 10)
    @Enumerated(EnumType.STRING)
    private CommunityMapperStatus status;

    //== 연관관계 메서드 ==//

    //== 생성 메서드 ==//
    public static CommunityMapper createCommunityMapper(
            Long userId,
            String nickname,
            String profileImage,
            CommunityRole role
    ) {
        CommunityMapper communityMapper = new CommunityMapper();
        communityMapper.setUserId(userId);
        communityMapper.setNickname(nickname);
        communityMapper.setProfileImage(profileImage);
        communityMapper.setMemo(null);
        communityMapper.setRole(role);
        communityMapper.setStatus(CommunityMapperStatus.NORMAL);

    }
}