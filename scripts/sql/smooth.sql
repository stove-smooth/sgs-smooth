-- community Table Create SQL
CREATE TABLE community
(
    `community_id`  BIGINT          NOT NULL    AUTO_INCREMENT COMMENT '커뮤니티 인덱스',
    `name`          VARCHAR(100)    NOT NULL    COMMENT '커뮤니티 이름',
    `icon_image`    TEXT            NOT NULL    COMMENT '아이콘 이미지',
    `is_public`     TINYINT(1)      NOT NULL    COMMENT '공개 서버 / 비공개 서버',
    `created_at`    DATETIME        NOT NULL    COMMENT '생성된 시간',
    `updated_at`    DATETIME        NOT NULL    COMMENT '수정된 시간',
    `status`        VARCHAR(10)     NOT NULL    COMMENT '상태',
     PRIMARY KEY (community_id)
);


-- category Table Create SQL
CREATE TABLE category
(
    `category_id`   BIGINT          NOT NULL    AUTO_INCREMENT COMMENT '카테고리 인덱스',
    `community_id`  BIGINT          NOT NULL    COMMENT '커뮤니티 인덱스',
    `name`          VARCHAR(200)    NOT NULL    COMMENT '카테고리 이름',
    `before_id`     BIGINT          NOT NULL    COMMENT '앞에 배치되어 있는 카테고리 인덱스',
    `created_at`    DATETIME        NOT NULL    COMMENT '생성된 시간',
    `updated_at`    DATETIME        NOT NULL    COMMENT '수정된 시간',
    `status`        VARCHAR(10)     NOT NULL    COMMENT '상태',
     PRIMARY KEY (category_id)
);

ALTER TABLE category
    ADD CONSTRAINT FK_category_community_id_community_community_id FOREIGN KEY (community_id)
        REFERENCES community (community_id) ON DELETE RESTRICT ON UPDATE RESTRICT;


-- room Table Create SQL
CREATE TABLE room
(
    `room_id`     BIGINT          NOT NULL    AUTO_INCREMENT COMMENT '방 인덱스',
    `owner`       BIGINT          NOT NULL    COMMENT '소유자의 유저 인덱스',
    `name`        VARCHAR(100)    NOT NULL    COMMENT '방 이름',
    `icon_image`  TEXT            NOT NULL    COMMENT '아이콘 이미지',
    `is_group`    TINYINT(1)      NOT NULL    COMMENT '그룹 메세지 여부',
    `created_at`  DATETIME        NOT NULL    COMMENT '생성된 시간',
    `updated_at`  DATETIME        NOT NULL    COMMENT '수정된 시간',
    `status`      VARCHAR(10)     NOT NULL    COMMENT '방 상태',
     PRIMARY KEY (room_id)
);


-- channel Table Create SQL
CREATE TABLE channel
(
    `channel_id`   BIGINT           NOT NULL    AUTO_INCREMENT COMMENT '채널 인덱스',
    `category_id`  BIGINT           NOT NULL    COMMENT '카테고리 인덱스',
    `user_id`      BIGINT           NOT NULL    COMMENT '생성한 유저의 인덱스',
    `name`         VARCHAR(200)     NOT NULL    COMMENT '최대 200자',
    `description`  VARCHAR(1024)    NOT NULL    COMMENT '소개',
    `type`         VARCHAR(10)      NOT NULL    COMMENT '채널 종류(채팅, 음성, etc.)',
    `is_public`    TINYINT(1)       NOT NULL    COMMENT '공개 채널 / 비공개 채널',
    `expired_at`   DATETIME         NOT NULL    COMMENT '스레드 유효기간',
    `parent_id`    BIGINT           NOT NULL    COMMENT '스래드 (부모) - 자기참조',
    `before_id`    BIGINT           NOT NULL    COMMENT '앞에 배치되어 있는 채널 인덱스',
    `created_at`   DATETIME         NOT NULL    COMMENT '생성된 시간',
    `updated_at`   DATETIME         NOT NULL    COMMENT '수정된 시간',
    `status`       VARCHAR(10)      NOT NULL    COMMENT '상태',
     PRIMARY KEY (channel_id)
);

ALTER TABLE channel
    ADD CONSTRAINT FK_channel_category_id_category_category_id FOREIGN KEY (category_id)
        REFERENCES category (category_id) ON DELETE RESTRICT ON UPDATE RESTRICT;


-- user Table Create SQL
CREATE TABLE user
(
    `user_id`        BIGINT          NOT NULL    AUTO_INCREMENT COMMENT '유저 인덱스',
    `email`          VARCHAR(255)    NOT NULL    COMMENT '이메일',
    `nickname`       VARCHAR(15)     NOT NULL    COMMENT '닉네임',
    `password`       CHAR(68)        NOT NULL    COMMENT '비밀번호',
    `profile_image`  TEXT            NOT NULL    COMMENT '프로필 이미지',
    `bio`            VARCHAR(190)    NOT NULL    COMMENT '한 줄 소개',
    `code`           CHAR(4)         NOT NULL    COMMENT '해쉬 코드',
    `role`           VARCHAR(20)     NOT NULL    COMMENT '역할',
    `nation_code`    VARCHAR(3)      NOT NULL    COMMENT '국가 코드',
    `language_code`  VARCHAR(3)      NOT NULL    COMMENT '언어 코드',
    `state`          VARCHAR(15)     NOT NULL    COMMENT '온라인/자리 비움/오프라인',
    `created_at`     DATETIME        NOT NULL    COMMENT '생성된 시간',
    `updated_at`     DATETIME        NOT NULL    COMMENT '수정된 시간',
    `status`         VARCHAR(20)     NOT NULL    COMMENT '유저 상태',
     PRIMARY KEY (user_id)
);


-- channel_member Table Create SQL
CREATE TABLE channel_member
(
    `channel_member_id`  BIGINT    NOT NULL    AUTO_INCREMENT COMMENT '채널 멤버 인덱스',
    `channel_id`         BIGINT    NOT NULL    COMMENT '채널 인덱스',
    `user_id`            BIGINT    NOT NULL    COMMENT '유저 인덱스',
     PRIMARY KEY (channel_member_id)
);

ALTER TABLE channel_member
    ADD CONSTRAINT FK_channel_member_channel_id_channel_channel_id FOREIGN KEY (channel_id)
        REFERENCES channel (channel_id) ON DELETE RESTRICT ON UPDATE RESTRICT;


-- community_invitation Table Create SQL
CREATE TABLE community_invitation
(
    `community_invitation_id`  BIGINT         NOT NULL    AUTO_INCREMENT COMMENT '초대 인덱스',
    `community_id`             BIGINT         NOT NULL    COMMENT '커뮤니티 인덱스',
    `user_id`                  BIGINT         NOT NULL    COMMENT '초대자',
    `code`                     CHAR(10)       NOT NULL    COMMENT '초대코드',
    `begin_at`                 DATETIME       NOT NULL    COMMENT '생성된 시간',
    `expired_at`               DATETIME       NOT NULL    COMMENT '만료 시간',
    `count`                    int            NOT NULL    COMMENT '사용 횟수',
    `max`                      int            NOT NULL    COMMENT '사용할 수 있는 횟수',
    `status`                   TINYTINT(1)    NOT NULL    COMMENT '사용 가능 여부',
     PRIMARY KEY (community_invitation_id)
);

ALTER TABLE community_invitation
    ADD CONSTRAINT FK_community_invitation_community_id_community_community_id FOREIGN KEY (community_id)
        REFERENCES community (community_id) ON DELETE RESTRICT ON UPDATE RESTRICT;


-- community_member Table Create SQL
CREATE TABLE community_member
(
    `community_member_id`  BIGINT          NOT NULL    AUTO_INCREMENT COMMENT 'community mapper 인덱스',
    `user_id`              BIGINT          NOT NULL    COMMENT '유저 인덱스',
    `community_id`         BIGINT          NOT NULL    COMMENT '커뮤니티 인덱스',
    `nickname`             VARCHAR(200)    NOT NULL    COMMENT '커뮤니티 프로필 이름',
    `profile_image`        TEXT            NOT NULL    COMMENT '커뮤니티 프로필 이미지',
    `role`                 VARCHAR(10)     NOT NULL    COMMENT '역할',
    `before_id`            BIGINT          NOT NULL    COMMENT '앞에 배치되어 있는 커뮤니티 인덱스',
    `created_at`           DATETIME        NOT NULL    COMMENT '생성된 시간',
    `updated_at`           DATETIME        NOT NULL    COMMENT '수정된 시간',
    `status`               VARCHAR(10)     NOT NULL    COMMENT '상태',
     PRIMARY KEY (community_member_id)
);

ALTER TABLE community_member
    ADD CONSTRAINT FK_community_member_user_id_user_user_id FOREIGN KEY (user_id)
        REFERENCES user (user_id) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE community_member
    ADD CONSTRAINT FK_community_member_community_id_community_community_id FOREIGN KEY (community_id)
        REFERENCES community (community_id) ON DELETE RESTRICT ON UPDATE RESTRICT;


-- room_member Table Create SQL
CREATE TABLE room_member
(
    `room_member_id`  BIGINT    NOT NULL    AUTO_INCREMENT COMMENT 'room mapper  인덱스',
    `user_id`         BIGINT    NOT NULL    COMMENT '유저 인덱스',
    `room_id`         BIGINT    NOT NULL    COMMENT '방 인덱스',
     PRIMARY KEY (room_member_id)
);

ALTER TABLE room_member
    ADD CONSTRAINT FK_room_member_user_id_user_user_id FOREIGN KEY (user_id)
        REFERENCES user (user_id) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE room_member
    ADD CONSTRAINT FK_room_member_room_id_room_room_id FOREIGN KEY (room_id)
        REFERENCES room (room_id) ON DELETE RESTRICT ON UPDATE RESTRICT;


-- friend Table Create SQL
CREATE TABLE friend
(
    `friend_id`   BIGINT        NOT NULL    AUTO_INCREMENT COMMENT '친구 테이블 인덱스',
    `sender`      BIGINT        NOT NULL    COMMENT '요청보낸 유저 인덱스',
    `receiver`    BIGINT        NOT NULL    COMMENT '요청받은 유저 인덱스',
    `created_at`  DATETIME      NOT NULL    COMMENT '생성된 시간',
    `updated_at`  DATETIME      NOT NULL    COMMENT '수정된 시간',
    `status`      VARCHAR(6)    NOT NULL    COMMENT 'WAIT / NORMAL / BAN',
     PRIMARY KEY (friend_id)
);

ALTER TABLE friend
    ADD CONSTRAINT FK_friend_sender_user_user_id FOREIGN KEY (sender)
        REFERENCES user (user_id) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE friend
    ADD CONSTRAINT FK_friend_receiver_user_user_id FOREIGN KEY (receiver)
        REFERENCES user (user_id) ON DELETE RESTRICT ON UPDATE RESTRICT;


-- device Table Create SQL
CREATE TABLE device
(
    `device_id`  BIGINT          NOT NULL    AUTO_INCREMENT COMMENT '디바이스 인덱스',
    `user_id`    BIGINT          NOT NULL    COMMENT '유저 인덱스',
    `type`       VARCHAR(20)     NOT NULL    COMMENT '접속 장비 종류',
    `token`      VARCHAR(200)    NOT NULL    COMMENT '장비 토큰',
    `access_at`  DATETIME        NOT NULL    COMMENT '마지막으로 로그인한 시간',
     PRIMARY KEY (device_id)
);

ALTER TABLE device
    ADD CONSTRAINT FK_device_user_id_user_user_id FOREIGN KEY (user_id)
        REFERENCES user (user_id) ON DELETE RESTRICT ON UPDATE RESTRICT;


-- category_member Table Create SQL
CREATE TABLE category_member
(
    `category_member_id`  BIGINT    NOT NULL    AUTO_INCREMENT COMMENT '카테고리 멤버 인덱스',
    `category_id`         BIGINT    NULL        COMMENT '카테고리 인덱스',
    `user_id`             BIGINT    NOT NULL    COMMENT '유저 인덱스',
     PRIMARY KEY (category_member_id)
);

ALTER TABLE category_member
    ADD CONSTRAINT FK_category_member_category_member_id_category_category_id FOREIGN KEY (category_member_id)
        REFERENCES category (category_id) ON DELETE RESTRICT ON UPDATE RESTRICT;


