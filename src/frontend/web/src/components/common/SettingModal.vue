<template>
  <div class="community-modal-container">
    <div class="community-setting-container">
      <div class="setting-sidebar">
        <slot name="setting-sidebar"></slot>
      </div>
      <div class="setting-content">
        <div class="setting-content-container">
          <slot name="setting-content"></slot>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {};
</script>

<style>
.community-modal-container {
  position: absolute;
  background-color: var(--white-color);
  width: 700px;
  max-height: 1000px;
  min-height: 500px;
  border-radius: 4px;
}
.community-setting-container {
  background: var(--white-color);
  opacity: 1;
  width: 700px;
  max-height: 1000px;
  min-height: 500px;
  border-radius: 4px;
  margin: 0 auto;
  pointer-events: all;
  position: relative;
  display: flex;
  flex-direction: row;
}
.setting-sidebar {
  flex-grow: 3;
  flex-basis: 0;
  background-color: #2f3136;
}
.setting-content {
  flex-grow: 5;
  flex-basis: 0;
  background-color: #202225;
}
.setting-content-container {
  flex: 1 1 auto;
  max-width: 740px;
  min-width: 460px;
  min-height: 440px;
  position: relative;
  padding: 60px 40px 80px;
}
</style>
