package com.example.communityserver.domain;

import com.example.communityserver.domain.type.CommonStatus;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "community")
@Getter @Setter
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

    @OneToMany(mappedBy = "community", cascade = CascadeType.ALL)
    private List<CommunityMember> members = new ArrayList<>();

    @OneToMany(mappedBy = "community", cascade = CascadeType.ALL)
    private List<CommunityInvitation> invitations = new ArrayList<>();

    @OneToMany(mappedBy = "community", cascade = CascadeType.ALL)
    private List<Category> categories = new ArrayList<>();

    @Column(length = 10)
    @Enumerated(EnumType.STRING)
    private CommonStatus status;

    //== 연관관계 메서드 ==//
    public void addCategory(Category category) {
        categories.add(category);
        category.setCommunity(this);
    }

    //== 생성 메서드 ==//
    public static Community createCommunity(
            String name,
            String iconImage,
            boolean isPublic,
            Category... categories
    ) {
        Community community = new Community();
        community.setName(name);
        community.setIconImage(iconImage);
        community.setPublic(isPublic);
        for (Category category: categories) {
            community.addCategory(category);
        }
        community.setStatus(CommonStatus.NORMAL);
        return community;
    }
}
