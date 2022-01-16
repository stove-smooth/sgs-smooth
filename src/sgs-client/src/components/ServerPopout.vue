<template>
  <div class="server-popout-container">
    <div class="guild-popout-menu">
      <div class="thin-scrollbar nav-scroller" v-bind:style="{ width: '100%' }">
        <div>
          <div class="plus-action-label-container">
            <div class="plus-action-label">서버 설정</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {};
</script>

<style>
.server-popout-container {
  position: absolute;
  left: 82px;
  top: 55.9883px;
}
.guild-popout-menu {
  width: 220px;
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
}
</style>
