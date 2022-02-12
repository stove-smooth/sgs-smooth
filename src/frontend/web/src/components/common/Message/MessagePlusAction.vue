<template>
  <div :style="cssProps" v-if="messagePlusMenu != null">
    <div class="message-plus-action-container">
      <div class="plus-action-wrapper">
        <div
          v-if="messagePlusMenu.userId == getUserId"
          class="plus-action-label-container"
          @click="setMessageEditId(messagePlusMenu.id)"
        >
          <div class="plus-action-label">메시지 수정하기</div>
          <svg class="edit-pencil"></svg>
        </div>
        <div
          class="plus-action-label-container"
          @click="messageReply(messagePlusMenu)"
        >
          <div class="plus-action-label">답장</div>
          <svg class="reply-button"></svg>
        </div>
        <div
          v-if="messagePlusMenu.userId == getUserId"
          class="plus-action-label-container hover-white"
          @click="messageDelete(messagePlusMenu.id)"
        >
          <div class="plus-action-label red-color">메시지 삭제하기</div>
          <svg class="trashcan"></svg>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapMutations, mapGetters } from "vuex";
export default {
  computed: {
    ...mapState("utils", ["clientX", "clientY"]),
    ...mapState("community", ["messagePlusMenu"]),
    ...mapGetters("user", ["getUserId"]),
    cssProps() {
      return {
        "--xpoint": this.clientX - 200 + "px",
        "--ypoint": this.clientY + "px",
      };
    },
  },
  methods: {
    ...mapMutations("community", [
      "setCommunityMessageReplyId",
      "setMessageEditId",
      "setMessageReadyToDelete",
    ]),
    ...mapMutations("dm", [
      "setDirectMessageReplyId",
      "setDirectMessageReadyToDelete",
    ]),
    messageReply(messagePlusMenu) {
      if (!this.$route.params.channelid) {
        const message = {
          channel: this.$route.params.id,
          messageInfo: messagePlusMenu,
        };
        this.setDirectMessageReplyId(message);
      } else {
        const message = {
          channel: this.$route.params.channelid,
          messageInfo: messagePlusMenu,
        };
        this.setCommunityMessageReplyId(message);
      }
    },
    messageDelete(id) {
      if (!this.$route.params.channelid) {
        this.setDirectMessageReadyToDelete(id);
      } else {
        this.setMessageReadyToDelete(id);
      }
    },
  },
};
</script>
<style>
.message-plus-action-container {
  position: absolute;
  top: var(--ypoint);
  left: var(--xpoint);
}
</style>
