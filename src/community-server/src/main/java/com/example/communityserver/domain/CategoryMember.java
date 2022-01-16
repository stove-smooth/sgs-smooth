package com.example.communityserver.domain;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Table(name = "category_member")
@Getter
@Setter
@NoArgsConstructor
public class CategoryMember {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "category_member_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private Category category;

    private Long userId;

    private boolean status;

    public CategoryMember(Long userId) {
        this.userId = userId;
        this.status = true;
    }
}
