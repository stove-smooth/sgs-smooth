<template>
  <div v-show="openServerPopout" class="server-popout-container">
    <div class="guild-popout-menu">
      <div class="thin-scrollbar nav-scroller" v-bind:style="{ width: '100%' }">
        <div>
          <div class="plus-action-label-container hover-white">
            <div class="plus-action-label discord-primary-color">
              친구 초대하기
            </div>
            <svg class="invite-people-primary-color"></svg>
          </div>
          <div class="plus-action-label-container">
            <div class="plus-action-label">서버 설정</div>
            <svg class="settings"></svg>
          </div>
          <div class="plus-action-label-container">
            <div class="plus-action-label">카테고리 만들기</div>
            <svg class="create-category"></svg>
          </div>
          <div class="plus-action-label-container">
            <div class="plus-action-label">알림 설정</div>
            <svg class="alarms"></svg>
          </div>
          <div class="plus-action-label-container hover-white">
            <div class="plus-action-label red-color">서버 나가기</div>
            <svg class="exit-server"></svg>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from "vuex";
export default {
  computed: {
    ...mapState("server", ["openServerPopout"]),
  },
};
</script>

<style>
.hover-white:hover {
  background-color: #fff;
}
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
.create-category {
  width: 16px;
  height: 16px;
  background-image: url("../assets/create-category.svg");
}
.invite-people-primary-color {
  width: 16px;
  height: 16px;
  background-image: url("../assets/invite-people-primary-color.svg");
}
.exit-server {
  width: 16px;
  height: 16px;
  background-image: url("../assets/exit-server.svg");
}
.alarms {
  width: 16px;
  height: 16px;
  background-image: url("../assets/alarms.svg");
}
.red-color {
  color: #ed4245;
}
.discord-primary-color {
  color: var(--discord-primary);
}
</style>
