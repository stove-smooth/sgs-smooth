package com.example.communityserver.domain;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Table(name = "channel_member")
@Getter
@Setter
@NoArgsConstructor
public class ChannelMember extends BaseTimeEntity{

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "channel_member_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "channel_id")
    private Channel channel;

    private Long userId;

    private boolean status;

    public ChannelMember(Long userId) {
        this.userId = userId;
        this.status = true;
    }

    public void delete() {
        this.status = false;
    }
}
