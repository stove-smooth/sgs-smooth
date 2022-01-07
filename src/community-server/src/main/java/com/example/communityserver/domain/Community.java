package com.example.communityserver.domain;

import com.example.communityserver.domain.type.CommunityStatus;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "community")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Community extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "community_id")
    private Long id;

    @Column(length = 100)
    private String name;

    private String iconImage;

    private boolean isPublic;

    @OneToMany(mappedBy = "community_mapper", cascade = CascadeType.ALL)
    private List<CommunityMapper> users = new ArrayList<>();

    @OneToMany(mappedBy = "community_invitation", cascade = CascadeType.ALL)
    private List<CommunityInvitation> invitations = new ArrayList<>();

    @OneToMany(mappedBy = "category", cascade = CascadeType.ALL)
    private List<Category> categories = new ArrayList<>();

    @Column(length = 10)
    @Enumerated(EnumType.STRING)
    private CommunityStatus status;
}
