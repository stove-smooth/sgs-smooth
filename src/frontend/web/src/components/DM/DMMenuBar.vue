<template>
  <section class="primary-header">
    <div class="header-children-wrapper">
      <div class="primary-icon-wrapper">
        <svg class="hashtag-icon"></svg>
      </div>
      <h3 class="server-name" aria-label="channel-name">
        {{ directMessageMemberList.name }}
      </h3>
    </div>
    <div class="primary-header-toolbar">
      <div
        aria-label="통화 시작하기"
        role="button"
        tabindex="0"
        class="primary-icon-wrapper clickable"
        @click="startCalling"
      >
        <svg class="call"></svg>
      </div>
      <div class="server-chatting-searchbar"><search-bar></search-bar></div>
    </div>
  </section>
</template>

<script>
import { mapState, mapMutations, mapActions, mapGetters } from "vuex";
import SearchBar from "../common/SearchBar.vue";
export default {
  components: {
    SearchBar,
  },
  computed: {
    ...mapState("dm", ["directMessageMemberList"]),
    ...mapState("voice", ["wsOpen", "video"]),
    ...mapGetters("user", ["getUserId", "getAccessToken"]),
  },
  methods: {
    ...mapMutations("voice", ["setVideo", "setCurrentVoiceRoom"]),
    ...mapActions("voice", [
      "wsInit",
      "sendMessage",
      "leaveRoom",
      "setVoiceInfo",
    ]),
    //dm 참가자들과 통화 시작.
    async startCalling() {
      console.log(this.$route.params.id);
      if (this.wsOpen) {
        this.sendMessage({ id: "leaveRoom" });
        this.leaveRoom();
        this.setCurrentVoiceRoom(null);
      }
      const url = "https://sig.yoloyolo.org/rtc";
      await this.wsInit(url); //ws 전역 등록.
      if (this.video) {
        this.setVideo();
      }
    },
  },
};
</script>

<style>
.call {
  background-image: url("../../assets/call.svg");
  width: 20px;
  height: 20px;
}
.call:hover {
  background-image: url("../../assets/call_on.svg");
  width: 20px;
  height: 20px;
}
</style>
