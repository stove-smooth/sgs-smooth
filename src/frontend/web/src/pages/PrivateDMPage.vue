<template>
  <div class="layer">
    <div class="content-mypage">
      <div class="sidebar">
        <friends-side-bar></friends-side-bar>
        <user-section></user-section>
      </div>
      <div class="friends-state-container" :key="$route.params.id">
        <dm-menu-bar></dm-menu-bar>
        <div class="friends-state-container2">
          <dm-activity-area></dm-activity-area>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import UserSection from "../components/common/UserSection.vue";
import DmActivityArea from "../components/DMActivityArea.vue";
import DmMenuBar from "../components/DMMenuBar.vue";
import FriendsSideBar from "../components/FriendsSideBar.vue";

export default {
  components: {
    FriendsSideBar,
    UserSection,
    DmActivityArea,
    DmMenuBar,
  },
};
</script>

<style></style>
