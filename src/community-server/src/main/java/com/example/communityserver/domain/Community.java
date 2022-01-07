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

    @OneToMany(mappedBy = "community_mapper", cascade = CascadeType.ALL)
    private List<CommunityMapper> users = new ArrayList<>();

    @OneToMany(mappedBy = "community_invitation", cascade = CascadeType.ALL)
    private List<CommunityInvitation> invitations = new ArrayList<>();

    @OneToMany(mappedBy = "category", cascade = CascadeType.ALL)
    private List<Category> categories = new ArrayList<>();

    @Column(length = 10)
    @Enumerated(EnumType.STRING)
    private CommonStatus status;

    - 이미지 원본
    - 이미지 섬네일
    - 타이틀
    - 공개/비공개

    //== 연관관계 메서드 ==//
    public void addUser(CommunityMapper communityMapper) {
        users.add(communityMapper);
        communityMapper.setCommunity(this);
    }

    //== 생성 메서드 ==//
    public static Community createCommunity(
            Long userId,

    ) {
        Community community = new Community();
        order.setMember(member);
        order.setDelivery(delivery);
        for (OrderItem orderItem: orderItems) {
            order.addOrderItem(orderItem);
        }
        order.setStatus(OrderStatus.ORDER);
        order.setOrderDate(LocalDateTime.now());
        return order;
    }

    //== 비즈니스 로직 ==//
}
