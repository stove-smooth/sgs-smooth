<template>
  <div :style="cssProps" v-show="friendsplusmenu">
    <div class="plus-action-container">
      <div class="plus-action-wrapper">
        <div class="plus-action-label-container">
          <div class="plus-action-label">영상 통화 시작하기</div>
        </div>
        <div class="plus-action-label-container">
          <div class="plus-action-label">음성 통화 시작하기</div>
        </div>
        <div class="plus-action-label-container">
          <div class="plus-action-label">친구하기</div>
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
    ...mapState("friends", ["friendsplusmenu"]),
    cssProps() {
      return {
        "--xpoint": this.clientX + "px",
        "--ypoint": this.clientY + "px",
      };
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
}
.plus-action-label {
  -webkit-box-flex: 1;
  flex: 1 1 auto;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
</style>
