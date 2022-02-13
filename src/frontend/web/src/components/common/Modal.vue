<template>
  <div :style="cssProps" class="create-server-form-wrapper">
    <div class="create-server-form-header">
      <slot name="header"></slot>
      <button
        class="close-button-wrapper"
        aria-label="닫기"
        type="button"
        @click="exitCreate"
      >
        <svg class="primary-close"></svg>
      </button>
    </div>
    <div class="create-server-form-content">
      <slot name="content"></slot>
    </div>
    <slot name="footer"></slot>
  </div>
</template>

<script>
export default {
  props: {
    backgroudColor: {
      type: String,
    },
  },
  methods: {
    exitCreate() {
      this.$emit("exit");
    },
  },
  computed: {
    cssProps() {
      return {
        "--modal-background": this.backgroudColor,
      };
    },
  },
};
</script>

<style>
.create-server-form-wrapper {
  background: var(--modal-background);
  opacity: 1;
  width: 440px;
  max-height: 720px;
  min-height: 200px;
  border-radius: 4px;
  margin: 0 auto;
  pointer-events: all;
  position: relative;
  display: flex;
  flex-direction: column;
}
.close-button-wrapper {
  position: absolute;
  top: 12px;
  right: 12px;
  height: 26px;
  cursor: pointer;
  border-radius: 3px;
  color: #4f5660;
  background-color: transparent;
  box-sizing: content-box;
  width: auto;
  border: 0;
  padding: 0;
  margin: 0;
}

.create-server-form-content {
  margin-top: 24px;
  padding: 0 8px 8px 16px;
}
</style>
