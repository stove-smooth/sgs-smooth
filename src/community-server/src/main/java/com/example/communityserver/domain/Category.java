package com.example.communityserver.domain;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "category")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Category {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "category_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "community_id")
    private Community community;

    @OneToMany(mappedBy = "channel", cascade = CascadeType.ALL)
    private List<Channel> channels = new ArrayList<>();

    @Column(length = 200)
    private String name;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "before_id")
    private Category before;
}
