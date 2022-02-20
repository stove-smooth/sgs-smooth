<template>
  <div :style="cssProps" v-if="communityMemberPlusMenu">
    <template v-if="communityMemberPlusMenu.id == getUserId">
      <div class="server-members-plus-action-container">
        <div
          class="plus-action-wrapper"
          @click="setFriendsProfileModal(communityMemberPlusMenu)"
        >
          <div class="plus-action-label-container">프로필</div>
        </div>
      </div>
    </template>
    <template v-else>
      <div class="server-members-plus-action-container">
        <div class="plus-action-wrapper">
          <div
            class="plus-action-label-container"
            @click="setFriendsProfileModal(communityMemberPlusMenu)"
          >
            <div class="plus-action-label">프로필</div>
          </div>
          <div
            class="plus-action-label-container"
            @click="sendDirectMessage(communityMemberPlusMenu.id)"
          >
            <div class="plus-action-label">메시지</div>
          </div>
          <div
            class="plus-action-label-container"
            @click="startCalling(communityMemberPlusMenu.id)"
          >
            <div class="plus-action-label">통화</div>
          </div>
          <div
            v-if="communityOwner"
            class="plus-action-label-container hover-white"
            @click="setCommunityReadyToBanish(communityMemberPlusMenu)"
          >
            <div class="plus-action-label red-color">추방하기</div>
          </div>
        </div>
      </div>
    </template>
  </div>
</template>

<script>
import { mapState, mapMutations, mapActions, mapGetters } from "vuex";
import { sendDirectMessage } from "@/utils/common";
export default {
  computed: {
    ...mapState("utils", ["clientX", "clientY", "stompSocketClient"]),
    ...mapState("community", ["communityMemberPlusMenu", "communityOwner"]),
    ...mapState("dm", ["directMessageList"]),
    ...mapState("voice", ["wsOpen", "video"]),
    ...mapState("user", ["nickname", "userimage"]),
    ...mapGetters("user", ["getUserId"]),
    cssProps() {
      return {
        "--xpoint": this.clientX - 190 + "px",
        "--ypoint": this.clientY + "px",
      };
    },
  },
  methods: {
    ...mapMutations("friends", ["setFriendsProfileModal"]),
    ...mapMutations("community", [
      "setCommunityReadyToExit",
      "setCommunityList",
      "setCommunityReadyToBanish",
    ]),
    ...mapMutations("voice", ["setVideo", "setCurrentVoiceRoom"]),
    ...mapActions("dm", ["fetchDirectMessageList"]),
    ...mapActions("voice", ["wsInit", "sendMessage", "leaveRoom"]),
    //1:1 메시지를 걸었을 경우 dm방을 찾아 있을 경우 이동하고, 없을 경우 생성 후 이동한다.
    async sendDirectMessage(userId) {
      await this.fetchDirectMessageList();
      const channelid = await sendDirectMessage(this.directMessageList, userId);
      if (this.$route.path !== `/channels/@me/${channelid}`) {
        this.$router.push(`/channels/@me/${channelid}`);
      }
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
      if (this.$route.path !== `/channels/@me/${channelid}`) {
        this.$router.push(`/channels/@me/${channelid}`);
      }
    },
  },
};
</script>

<style>
.server-members-plus-action-container {
  position: absolute;
  top: var(--ypoint);
  left: var(--xpoint);
}
</style>
