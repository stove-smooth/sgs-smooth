<template>
  <div :style="cssProps" v-show="messagePlusMenu != null">
    <div class="message-plus-action-container">
      <div class="plus-action-wrapper">
        <div
          class="plus-action-label-container"
          @click="setMessageEditId(messagePlusMenu.id)"
        >
          <div class="plus-action-label">메시지 수정하기</div>
          <svg class="edit-pencil"></svg>
        </div>
        <div
          class="plus-action-label-container"
          @click="setMessageFixId(messagePlusMenu.id)"
        >
          <div class="plus-action-label">메시지 고정하기</div>
          <svg class="fixed-icon"></svg>
        </div>
        <div
          class="plus-action-label-container"
          @click="setMessageReplyId(messagePlusMenu)"
        >
          <div class="plus-action-label">답장</div>
          <svg class="reply-button"></svg>
        </div>
        <div class="plus-action-label-container">
          <div class="plus-action-label">스레드 만들기</div>
          <svg class="thread-icon"></svg>
        </div>
        <div
          class="plus-action-label-container hover-white"
          @click="setMessageReadyToDelete(messagePlusMenu.id)"
        >
          <div class="plus-action-label red-color">메시지 삭제하기</div>
          <svg class="trashcan"></svg>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapMutations } from "vuex";
export default {
  computed: {
    ...mapState("utils", ["clientX", "clientY"]),
    ...mapState("server", [
      "messagePlusMenu",
      "messageReplyId",
      "messageEditId",
      "messageReadyToDelete",
    ]),
    cssProps() {
      return {
        "--xpoint": this.clientX + "px",
        "--ypoint": this.clientY + "px",
      };
    },
  },
  methods: {
    ...mapMutations("server", [
      "setMessageReplyId",
      "setMessageEditId",
      "setMessageFixId",
      "setMessageReadyToDelete",
    ]),
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
