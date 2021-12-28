-- Server Table Create SQL
CREATE TABLE Server
(
    `server_id`   BIGINT          NOT NULL    AUTO_INCREMENT,
    `title`       VARCHAR(200)    NOT NULL    COMMENT '최대 200자',
    `icon_image`  TEXT            NULL,
    `is_public`   TINYINT(1)      NOT NULL    COMMENT '공개/비공개',
    `created_dt`  DATETIME        NOT NULL,
    `updated_dt`  DATETIME        NOT NULL,
    `status`      VARCHAR(20)     NOT NULL    COMMENT '상태 정보',
     PRIMARY KEY (server_id)
);


-- Account Table Create SQL
CREATE TABLE Account
(
    `account_id`     BIGINT          NOT NULL    AUTO_INCREMENT,
    `email`          VARCHAR(255)    NOT NULL,
    `nickname`       VARCHAR(15)     NOT NULL,
    `password`       CHAR(64)        NOT NULL,
    `profile_image`  TEXT            NOT NULL,
    `role`           VARCHAR(20)     NOT NULL,
    `status`         VARCHAR(20)     NOT NULL,
     PRIMARY KEY (account_id)
);


-- Room Table Create SQL
CREATE TABLE Room
(
    `room_id`     BIGINT          NOT NULL    AUTO_INCREMENT,
    `name`        VARCHAR(100)    NOT NULL    COMMENT '친구 이름 또는 여러 명',
    `icon_image`  TEXT            NULL,
    `createdAt`   DATETIME        NOT NULL,
    `updatedAt`   DATETIME        NOT NULL,
    `status`      VARCHAR(20)     NOT NULL,
     PRIMARY KEY (room_id)
);


-- Channel Table Create SQL
CREATE TABLE Channel
(
    `channel_id`  BIGINT          NOT NULL    AUTO_INCREMENT,
    `server_id`   BIGINT          NOT NULL,
    `title`       VARCHAR(200)    NOT NULL    COMMENT '최대 200자',
    `type`        TINYINT         NOT NULL    COMMENT '채널 종류(채팅, 음성, etc.)',
    `isPublic`    TINYINT(1)      NOT NULL    COMMENT '채널 공개/비공개',
    `category`    INT             NOT NULL    COMMENT '카테고리(부모) - 자기참조',
    `createdAt`   DATETIME        NOT NULL,
    `updatedAt`   DATETIME        NOT NULL,
    `status`      VARCHAR(20)     NOT NULL    COMMENT '상태 정보',
     PRIMARY KEY (channel_id)
);

ALTER TABLE Channel
    ADD CONSTRAINT FK_Channel_server_id_Server_server_id FOREIGN KEY (server_id)
        REFERENCES Server (server_id) ON DELETE RESTRICT ON UPDATE RESTRICT;


-- UserServerWrapper Table Create SQL
CREATE TABLE UserServerWrapper
(
    `user_server_wrapper_id`  BIGINT    NOT NULL    AUTO_INCREMENT,
    `account_id`              BIGINT    NOT NULL,
    `server_id`               BIGINT    NOT NULL,
     PRIMARY KEY (user_server_wrapper_id)
);

ALTER TABLE UserServerWrapper
    ADD CONSTRAINT FK_UserServerWrapper_account_id_Account_account_id FOREIGN KEY (account_id)
        REFERENCES Account (account_id) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE UserServerWrapper
    ADD CONSTRAINT FK_UserServerWrapper_server_id_Server_server_id FOREIGN KEY (server_id)
        REFERENCES Server (server_id) ON DELETE RESTRICT ON UPDATE RESTRICT;


-- ServerProfile Table Create SQL
CREATE TABLE ServerProfile
(
    `server_profile_id`       BIGINT          NOT NULL    AUTO_INCREMENT,
    `user_server_wrapper_id`  BIGINT          NOT NULL,
    `name`                    VARCHAR(200)    NOT NULL,
    `profile_image_id`        INT             NOT NULL,
    `role`                    VARCHAR(20)     NOT NULL    COMMENT '역할',
    `is_suspended`            TINYINY(1)      NOT NULL,
     PRIMARY KEY (server_profile_id)
);

ALTER TABLE ServerProfile
    ADD CONSTRAINT FK_ServerProfile_user_server_wrapper_id_UserServerWrapper_user_s FOREIGN KEY (user_server_wrapper_id)
        REFERENCES UserServerWrapper (user_server_wrapper_id) ON DELETE RESTRICT ON UPDATE RESTRICT;


-- ChannelMember Table Create SQL
CREATE TABLE ChannelMember
(
    `channel_member_id`  BIGINT    NOT NULL    AUTO_INCREMENT,
    `channel_id`         BIGINT    NOT NULL,
    `account_id`         BIGINT    NOT NULL,
     PRIMARY KEY (channel_member_id)
);

ALTER TABLE ChannelMember
    ADD CONSTRAINT FK_ChannelMember_channel_id_Channel_channel_id FOREIGN KEY (channel_id)
        REFERENCES Channel (channel_id) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE ChannelMember
    ADD CONSTRAINT FK_ChannelMember_account_id_Account_account_id FOREIGN KEY (account_id)
        REFERENCES Account (account_id) ON DELETE RESTRICT ON UPDATE RESTRICT;


-- ChannelMessage Table Create SQL
CREATE TABLE ChannelMessage
(
    `channel_message_id`  BIGINT         NOT NULL    AUTO_INCREMENT,
    `channel_id`          BIGINT         NOT NULL,
    `account_id`          BIGINT         NOT NULL,
    `content`             TEXT           NOT NULL,
    `type`                TINYINT        NOT NULL,
    `createdAt`           DATETIME       NOT NULL,
    `updatedAt`           DATETIME       NOT NULL,
    `status`              VARCHAR(20)    NOT NULL,
     PRIMARY KEY (channel_message_id)
);


-- ServerInvitation Table Create SQL
CREATE TABLE ServerInvitation
(
    `server_invitation_id`  BIGINT         NOT NULL    AUTO_INCREMENT,
    `server_id`             BIGINT         NOT NULL,
    `uri`                   VARCHAR(20)    NOT NULL,
    `begin_dt`              DATETIME       NOT NULL,
    `expired_dt`            DATETIME       NOT NULL,
     PRIMARY KEY (server_invitation_id)
);

ALTER TABLE ServerInvitation
    ADD CONSTRAINT FK_ServerInvitation_server_id_Server_server_id FOREIGN KEY (server_id)
        REFERENCES Server (server_id) ON DELETE RESTRICT ON UPDATE RESTRICT;


-- UserRoomWrapper Table Create SQL
CREATE TABLE UserRoomWrapper
(
    `user_room_wrapper_id`  BIGINT    NOT NULL    AUTO_INCREMENT,
    `account_id`            BIGINT    NULL,
    `room_id`               BIGINT    NULL,
     PRIMARY KEY (user_room_wrapper_id)
);

ALTER TABLE UserRoomWrapper
    ADD CONSTRAINT FK_UserRoomWrapper_account_id_Account_account_id FOREIGN KEY (account_id)
        REFERENCES Account (account_id) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE UserRoomWrapper
    ADD CONSTRAINT FK_UserRoomWrapper_room_id_Room_room_id FOREIGN KEY (room_id)
        REFERENCES Room (room_id) ON DELETE RESTRICT ON UPDATE RESTRICT;


-- RoomMessage Table Create SQL
CREATE TABLE RoomMessage
(
    `room_message_id`  BIGINT    NOT NULL    AUTO_INCREMENT,
    `room_id`          BIGINT    NOT NULL,
    `account_id`       BIGINT    NOT NULL,
    `content`          TEXT      NOT NULL,
     PRIMARY KEY (room_message_id)
);


-- Friend Table Create SQL
CREATE TABLE Friend
(
    `friend_id`  BIGINT         NOT NULL    AUTO_INCREMENT,
    `sender`     BIGINT         NOT NULL    COMMENT 'account_id',
    `receiver`   BIGINT         NOT NULL    COMMENT 'account_id',
    `status`     VARCHAR(20)    NOT NULL    COMMENT 'WAIT / NORMAL / SUSPENDED',
     PRIMARY KEY (friend_id)
);

ALTER TABLE Friend
    ADD CONSTRAINT FK_Friend_sender_Account_account_id FOREIGN KEY (sender)
        REFERENCES Account (account_id) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE Friend
    ADD CONSTRAINT FK_Friend_receiver_Account_account_id FOREIGN KEY (receiver)
        REFERENCES Account (account_id) ON DELETE RESTRICT ON UPDATE RESTRICT;