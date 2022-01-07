<template>
  <div class="create-server-form-wrapper">
    <div class="create-server-form-header">
      <slot name="header"></slot>
      <button
        class="close-button-wrapper"
        aria-label="닫기"
        type="button"
        @click="exitCreate"
      >
        <svg class="close-dm"></svg>
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
  methods: {
    exitCreate() {
      this.$emit("exit");
    },
  },
};
</script>

<style></style>
