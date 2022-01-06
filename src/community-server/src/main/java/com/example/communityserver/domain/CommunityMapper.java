package com.example.communityserver.domain;

import com.example.communityserver.domain.type.CommunityMapperStatus;
import com.example.communityserver.domain.type.CommunityRole;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Entity
@Table(name = "community_mapper")
@Getter
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

    @Column(length = 10)
    @Enumerated(EnumType.STRING)
    private CommunityRole role;

    @Column(length = 10)
    @Enumerated(EnumType.STRING)
    private CommunityMapperStatus status;
}
