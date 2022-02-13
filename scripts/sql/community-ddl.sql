create table `sgs-server`.community
(
    community_id bigint auto_increment
        primary key,
    created_at   datetime(6)  null,
    updated_at   datetime(6)  null,
    icon_image   varchar(255) null,
    is_public    bit          not null,
    name         varchar(100) null,
    status       varchar(10)  null
);

create table `sgs-server`.category
(
    category_id             bigint auto_increment
        primary key,
    created_at              datetime(6)  null,
    updated_at              datetime(6)  null,
    is_public               bit          not null,
    name                    varchar(200) null,
    status                  varchar(255) null,
    before_node_category_id bigint       null,
    community_id            bigint       null,
    next_node_category_id   bigint       null,
    constraint FKjy1mf290idn4p9uool2sefqmu
        foreign key (community_id) references `sgs-server`.community (community_id),
    constraint FKkaqcxfwin757b6t2e2gpbv01h
        foreign key (next_node_category_id) references `sgs-server`.category (category_id),
    constraint FKovuheir2xa9tjbyakycqsxm23
        foreign key (before_node_category_id) references `sgs-server`.category (category_id)
);

create table `sgs-server`.category_member
(
    category_member_id bigint auto_increment
        primary key,
    status             bit    not null,
    user_id            bigint null,
    category_id        bigint null,
    constraint FKkpoirf7iku46drtl4dmu3p6er
        foreign key (category_id) references `sgs-server`.category (category_id)
);

create table `sgs-server`.channels
(
    channel_id             bigint auto_increment
        primary key,
    created_at             datetime(6)   null,
    updated_at             datetime(6)   null,
    description            varchar(1024) null,
    expired_at             datetime(6)   null,
    is_public              bit           not null,
    message_id             bigint        null,
    name                   varchar(200)  null,
    status                 varchar(10)   null,
    type                   varchar(255)  null,
    username               varchar(255)  null,
    before_node_channel_id bigint        null,
    category_id            bigint        null,
    next_node_channel_id   bigint        null,
    parent_id              bigint        null,
    constraint FK5ucyhbmd0im7tjfanrdeao4jf
        foreign key (parent_id) references `sgs-server`.channels (channel_id),
    constraint FKbe1rysrbux0kvusflw5fqbo8y
        foreign key (next_node_channel_id) references `sgs-server`.channels (channel_id),
    constraint FKnt0e0rp8ce2631g0ys4dkycuu
        foreign key (category_id) references `sgs-server`.category (category_id),
    constraint FKr7t0vncx4uvdn3oobbd5gikl7
        foreign key (before_node_channel_id) references `sgs-server`.channels (channel_id)
);

create table `sgs-server`.channel_member
(
    channel_member_id bigint auto_increment
        primary key,
    created_at        datetime(6) null,
    updated_at        datetime(6) null,
    status            bit         not null,
    user_id           bigint      null,
    channel_id        bigint      null,
    constraint FKgmcpo8luh1eilwiqvxb7p1dyb
        foreign key (channel_id) references `sgs-server`.channels (channel_id)
);

create table `sgs-server`.community_invitation
(
    community_invitation_id bigint auto_increment
        primary key,
    created_at              datetime(6) null,
    updated_at              datetime(6) null,
    activate                bit         not null,
    code                    varchar(10) null,
    user_id                 bigint      null,
    community_id            bigint      null,
    constraint FKoqvtmshini6017ol5ega695jy
        foreign key (community_id) references `sgs-server`.community (community_id)
);

create table `sgs-server`.community_member
(
    community_member_id             bigint auto_increment
        primary key,
    created_at                      datetime(6)  null,
    updated_at                      datetime(6)  null,
    memo                            varchar(256) null,
    nickname                        varchar(200) null,
    profile_image                   varchar(255) null,
    role                            varchar(10)  null,
    status                          varchar(10)  null,
    user_id                         bigint       null,
    before_node_community_member_id bigint       null,
    community_id                    bigint       null,
    next_node_community_member_id   bigint       null,
    constraint FKifo6nyplwhcmwjhij52q7qlhx
        foreign key (community_id) references `sgs-server`.community (community_id),
    constraint FKkbnp8hboj8kdevy2tqw5yvgb3
        foreign key (before_node_community_member_id) references `sgs-server`.community_member (community_member_id),
    constraint FKl14rrq855ggsenwt59igmb679
        foreign key (next_node_community_member_id) references `sgs-server`.community_member (community_member_id)
);

create table `sgs-server`.room
(
    room_id    bigint auto_increment
        primary key,
    created_at datetime(6)  null,
    updated_at datetime(6)  null,
    icon_image varchar(255) null,
    is_group   bit          null,
    name       varchar(100) null,
    status     varchar(255) null
);

create table `sgs-server`.room_invitation
(
    room_invitation_id bigint auto_increment
        primary key,
    created_at         datetime(6) null,
    updated_at         datetime(6) null,
    code               varchar(10) null,
    expired_at         datetime(6) null,
    room_id            bigint      null,
    constraint FKo7xoj467fir0np8fntb28opgv
        foreign key (room_id) references `sgs-server`.room (room_id)
);

create table `sgs-server`.room_member
(
    room_member_id bigint auto_increment
        primary key,
    created_at     datetime(6)  null,
    updated_at     datetime(6)  null,
    owner          bit          not null,
    status         varchar(255) null,
    user_id        bigint       null,
    room_id        bigint       null,
    constraint FKlmp67erahqx7u5shbkc12p0lw
        foreign key (room_id) references `sgs-server`.room (room_id)
);