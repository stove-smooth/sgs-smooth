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
import java.util.Objects;

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

    @OneToMany(mappedBy = "category", cascade = CascadeType.ALL)
    private List<Channel> channels = new ArrayList<>();

    @Column(length = 200)
    private String name;

    @OneToOne(fetch = FetchType.LAZY)
    private Category beforeNode;

    @OneToOne(fetch = FetchType.LAZY)
    private Category nextNode;

    private boolean isPublic;

    @OneToMany(mappedBy = "category", cascade = CascadeType.ALL)
    private List<CategoryMember> members = new ArrayList<>();

    @Enumerated(EnumType.STRING)
    private CommonStatus status;

    //== 연관관계 메서드 ==//
    public void addMember(CategoryMember categoryMember) {
        members.add(categoryMember);
        categoryMember.setCategory(this);
    }

    public void setNextNode(Category nextNode) {
        this.nextNode = nextNode;
        if (!Objects.isNull(nextNode))
            nextNode.setBeforeNode(this);
    }

    //== 생성 메서드 ==//
    public static Category createCategory(
        String name,
        boolean isPublic,
        Category nextNode,
        List<CategoryMember> categoryMembers
    ) {
        Category category = new Category();
        category.setName(name);
        category.setPublic(isPublic);
        if (!isPublic) {
            for (CategoryMember categoryMember: categoryMembers) {
                category.addMember(categoryMember);
            }
        }
        category.setNextNode(nextNode);
        category.setStatus(CommonStatus.NORMAL);
        return category;
    }

    public void locate(Category tobe, Category first) {
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
        this.setStatus(CommonStatus.DELETED);
    }
}