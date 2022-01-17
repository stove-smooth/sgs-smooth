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

    @Column(columnDefinition = "TINYINT(1) DEFAULT TRUE")
    private boolean isFirstNode;

    @OneToOne(fetch = FetchType.LAZY)
    private Category nextNode;

    private boolean isPublic;

    @OneToMany(mappedBy = "category", cascade = CascadeType.ALL)
    private List<CategoryMember> members = new ArrayList<>();

    private CommonStatus status;

    //== 연관관계 메서드 ==//
    public void addMember(CategoryMember categoryMember) {
        members.add(categoryMember);
        categoryMember.setCategory(this);
    }

    public void setNextNode(Category nextNode) {
        this.nextNode = nextNode;
        if (!Objects.isNull(nextNode))
            nextNode.isFirstNode = false;
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
        category.setFirstNode(true);
        category.setNextNode(nextNode);
        category.setStatus(CommonStatus.NORMAL);
        return category;
    }

    public void locate(Category before, Category first) {
        Category originBeforeNode = first;
        
        if (first.equals(this)) {
            this.isFirstNode = false;
            Category originNextNode = before.getNextNode();
            before.setNextNode(this);
            this.getNextNode().setFirstNode(true);
            this.setNextNode(originNextNode);
        } else {
            while (!Objects.isNull(originBeforeNode.getNextNode())) {
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
                Category originNextNode = before.getNextNode();
                before.setNextNode(this);
                if (!Objects.isNull(originNextNode))
                    originNextNode.setNextNode(this.nextNode);
                this.nextNode = originNextNode;
                originBeforeNode.setNextNode(before);
            }
        }
    }

    public void delete() {
        if (this.isFirstNode) {
            if (!Objects.isNull(this.getNextNode()))
                this.getNextNode().isFirstNode = true;
            this.isFirstNode = false;
        }
        for (Channel channel: this.getChannels()) {
            channel.delete();
        }
        for (CategoryMember member: this.getMembers()) {
            member.delete();
        }
        this.setStatus(CommonStatus.DELETED);
    }
}
