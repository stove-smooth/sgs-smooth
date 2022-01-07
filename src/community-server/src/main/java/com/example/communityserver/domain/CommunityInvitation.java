package com.example.communityserver.domain;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "community_invitation")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class CommunityInvitation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "community_invitation_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "community_id")
    private Community community;

    private Long userId;

    @Column(length = 8)
    private String code;

    @CreatedDate
    private LocalDateTime createdAt;

    private LocalDateTime expiredAt;

    private int count;
}
