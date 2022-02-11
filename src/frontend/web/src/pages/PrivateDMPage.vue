<template>
  <div class="layer">
    <div class="content-mypage" :key="$route.params.id">
      <div class="sidebar">
        <friends-side-bar />
        <user-section />
      </div>
      <div class="friends-state-container">
        <dm-menu-bar />
        <div class="friends-state-container2">
          <div class="dm-activity-container">
            <div v-if="wsOpen"><voice-sharing-area /></div>
            <dm-activity-area />
          </div>
          <dm-member-list />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from "vuex";
import UserSection from "../components/common/UserSection.vue";
import DmActivityArea from "../components/DMActivityArea.vue";
import DmMemberList from "../components/DMMemberList.vue";
import DmMenuBar from "../components/DMMenuBar.vue";
import FriendsSideBar from "../components/FriendsSideBar.vue";
import VoiceSharingArea from "../components/VoiceSharingArea.vue";
export default {
  components: {
    FriendsSideBar,
    UserSection,
    DmActivityArea,
    DmMenuBar,
    DmMemberList,
    VoiceSharingArea,
  },
  computed: {
    ...mapState("voice", ["wsOpen"]),
  },
};
</script>

<style>
.dm-activity-container {
  display: flex;
  flex-direction: column;
  flex: 1 1 auto;
}
</style>
