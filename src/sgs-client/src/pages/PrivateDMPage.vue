<template>
  <div class="layer">
    <div class="content-mypage">
      <div class="sidebar">
        <friends-side-bar></friends-side-bar>
        <user-section></user-section>
      </div>
      <div class="friends-state-container">
        <server-chatting-menu-bar></server-chatting-menu-bar>
        <div class="friends-state-container2">
          <server-activity-area></server-activity-area>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import UserSection from "../components/common/UserSection.vue";
import FriendsSideBar from "../components/FriendsSideBar.vue";
import ServerActivityArea from "../components/ServerActivityArea.vue";
import ServerChattingMenuBar from "../components/ServerChattingMenuBar.vue";
export default {
  components: {
    FriendsSideBar,
    UserSection,
    ServerChattingMenuBar,
    ServerActivityArea,
  },
};
</script>

<style></style>
