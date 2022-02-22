<template>
  <div :style="cssProps" v-show="friendsPlusMenu">
    <div class="plus-action-container">
      <div class="plus-action-wrapper">
        <div
          class="plus-action-label-container"
          @mouseover="hover('profile')"
          @click="setFriendsProfileModal(friendsPlusMenu)"
        >
          <div class="plus-action-label">프로필</div>
        </div>
        <div
          class="plus-action-label-container"
          @mouseover="hover('call')"
          @click="startCalling(friendsPlusMenu.userId)"
        >
          <div class="plus-action-label">통화 시작하기</div>
        </div>
        <div
          class="plus-action-label-container hover-white"
          @click="setFriendsReadyToDelete(friendsPlusMenu)"
          @mouseover="hover('remove')"
        >
          <div class="plus-action-label red-color">친구 삭제하기</div>
        </div>
        <div
          class="plus-action-label-container hover-white"
          @click="setFriendsReadyToBlock(friendsPlusMenu)"
          @mouseover="hover('block')"
        >
          <div class="plus-action-label red-color">차단하기</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapMutations, mapActions, mapGetters } from "vuex";
import { sendDirectMessage } from "@/utils/common";
export default {
  data() {
    return {
      readytoinvite: "",
    };
  },
  computed: {
    ...mapState("utils", ["clientX", "clientY", "stompSocketClient"]),
    ...mapState("dm", ["directMessageList"]),
    ...mapState("friends", ["friendsPlusMenu"]),
    ...mapState("voice", ["wsOpen", "video"]),
    ...mapState("user", ["nickname", "userimage"]),
    ...mapGetters("user", ["getUserId"]),
    cssProps() {
      return {
        "--xpoint": this.clientX + "px",
        "--ypoint": this.clientY + "px",
        "--plus--xpoint": this.clientX + 190 + "px",
        "--plus--ypoint": this.clientY + 96 + "px",
      };
    },
  },
  methods: {
    ...mapActions("voice", ["wsInit", "sendMessage", "leaveRoom"]),
    ...mapMutations("friends", [
      "setFriendsReadyToDelete",
      "setFriendsReadyToBlock",
      "setFriendsProfileModal",
    ]),
    ...mapMutations("voice", ["setVideo", "setCurrentVoiceRoom"]),
    hover(element) {
      this.readytoinvite = element;
    },
    async startCalling(userId) {
      const channelid = await sendDirectMessage(this.directMessageList, userId);

      if (this.wsOpen) {
        this.sendMessage({ id: "leaveRoom" });
        this.leaveRoom();
        this.setCurrentVoiceRoom(null);
      }
      const wsInfo = {
        url: process.env.VUE_APP_WEBRTC_URL,
        type: "room",
      };
      await this.wsInit(wsInfo); //ws 전역 등록.
      if (this.video) {
        this.setVideo();
      }
      const msg = {
        content: `<~dmcalling~>${this.nickname}님이 통화를 시작했어요. `,
        channelId: channelid,
        userId: this.getUserId,
        name: this.nickname,
        profileImage: this.userimage,
      };
      this.stompSocketClient.send(
        "/kafka/send-direct-message",
        JSON.stringify(msg),
        {}
      );
      this.$router.push(`/channels/@me/${channelid}`);
    },
  },
};
</script>

<style>
.plus-action-container {
  position: absolute;
  top: var(--ypoint);
  left: var(--xpoint);
}
.plus-action-wrapper {
  min-width: 188px;
  max-width: 320px;
  position: relative;
  z-index: 1;
  box-sizing: border-box;
  display: flex;
  height: auto;
  cursor: default;
  max-height: calc(100vh - 32px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.24);
  background: #18191c;
  border-radius: 4px;
  flex-direction: column;
}
.plus-action-label-container {
  box-sizing: border-box;
  display: flex;
  -webkit-box-pack: justify;
  justify-content: space-between;
  -webkit-box-align: center;
  align-items: center;
  min-height: 32px;
  padding: 6px 8px;
  color: #b9bbbe;
  border-color: #b9bbbe;
  position: relative;
  margin: 2px 0;
  border-radius: 2px;
  font-size: 14px;
  font-weight: 500;
  line-height: 18px;
  cursor: pointer;
}
.plus-action-label-container:hover {
  background-color: var(--discord-primary);
}
.plus-action-label {
  -webkit-box-flex: 1;
  flex: 1 1 auto;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.small-right-arrow {
  width: 12px;
  height: 12px;
  background-image: url("../../assets/small-right-arrow.svg");
}
</style>
