<template>
  <div :style="cssProps" v-show="serverMemberPlusMenu">
    <div class="server-members-plus-action-container">
      <div class="plus-action-wrapper">
        <div class="plus-action-label-container">
          <div class="plus-action-label">프로필</div>
        </div>
        <div class="plus-action-label-container">
          <div class="plus-action-label">메시지</div>
        </div>
        <div class="plus-action-label-container">
          <div class="plus-action-label">통화</div>
        </div>
        <div class="plus-action-label-container hover-white">
          <div class="plus-action-label red-color">추방하기</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from "vuex";
export default {
  computed: {
    ...mapState("utils", ["clientX", "clientY"]),
    ...mapState("server", ["serverMemberPlusMenu"]),
    cssProps() {
      return {
        "--xpoint": this.clientX - 190 + "px",
        "--ypoint": this.clientY + "px",
      };
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
