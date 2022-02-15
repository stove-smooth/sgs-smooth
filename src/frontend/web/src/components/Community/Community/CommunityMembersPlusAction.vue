<template>
  <div :style="cssProps" v-if="communityMemberPlusMenu">
    <template v-if="communityMemberPlusMenu.id == getUserId">
      <div class="server-members-plus-action-container">
        <div class="plus-action-wrapper">
          <div class="plus-action-label-container">프로필</div>
        </div>
      </div>
    </template>
    <template v-else>
      <div class="server-members-plus-action-container">
        <div class="plus-action-wrapper">
          <div class="plus-action-label-container">
            <div class="plus-action-label">프로필</div>
          </div>
          <div
            class="plus-action-label-container"
            @click="sendDirectMessage(communityMemberPlusMenu.id)"
          >
            <div class="plus-action-label">메시지</div>
          </div>
          <div class="plus-action-label-container">
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
    ...mapState("utils", ["clientX", "clientY"]),
    ...mapState("community", ["communityMemberPlusMenu", "communityOwner"]),
    ...mapState("dm", ["directMessageList"]),
    ...mapGetters("user", ["getUserId"]),
    cssProps() {
      return {
        "--xpoint": this.clientX - 190 + "px",
        "--ypoint": this.clientY + "px",
      };
    },
  },
  methods: {
    ...mapMutations("community", [
      "setCommunityReadyToExit",
      "setCommunityList",
      "setCommunityReadyToBanish",
    ]),
    ...mapActions("dm", ["fetchDirectMessageList"]),
    //1:1 메시지를 걸었을 경우 dm방을 찾아 있을 경우 이동하고, 없을 경우 생성 후 이동한다.
    async sendDirectMessage(userId) {
      await this.fetchDirectMessageList();
      await sendDirectMessage(this.directMessageList, userId);
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
