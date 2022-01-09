package com.example.communityserver.domain;

import com.example.communityserver.domain.type.CommonStatus;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "category")
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Category extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "category_id")
    private Long id;

    @JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "community_id")
    private Community community;

    @OneToMany(mappedBy = "channels", cascade = CascadeType.ALL)
    private List<Channel> channels = new ArrayList<>();

    @Column(length = 200)
    private String name;

    private Long before;

    private boolean isPublic;

    @OneToMany(mappedBy = "categoryMember", cascade = CascadeType.ALL)
    private List<CategoryMember> members = new ArrayList<>();

    private CommonStatus status;

    //== 연관관계 메서드 ==//
    public void addMember(CategoryMember categoryMember) {
        members.add(categoryMember);
        categoryMember.setCategory(this);
    }

    //== 생성 메서드 ==//
    public static Category createCategory(
        String name,
        boolean isPublic,
        CategoryMember... members
    ) {
        Category category = new Category();
        category.setName(name);
        category.setPublic(isPublic);
        if (!isPublic) {
            for (CategoryMember member: members) {
                category.addMember(member);
            }
        }
        category.setBefore(null);
        category.setStatus(CommonStatus.NORMAL);
        return category;
    }
}
