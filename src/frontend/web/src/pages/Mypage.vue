<template>
  <div class="layer">
    <div class="content-mypage">
      <div class="sidebar">
        <friends-side-bar />
        <user-section />
      </div>
      <div class="friends-state-container">
        <friends-state-menu-bar />
        <div class="friends-state-container2">
          <template v-if="friendsStateMenu === 'addfriends'">
            <friends-new-add />
          </template>
          <template v-else>
            <friends-state-list />
          </template>
          <friends-now-playing-list />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapState } from "vuex";

import FriendsSideBar from "../components/Friends/FriendsSideBar.vue";
import FriendsStateList from "../components/Friends/FriendsStateList.vue";
import FriendsStateMenuBar from "../components/Friends/FriendsStateMenuBar.vue";
import UserSection from "../components/common/UserSection.vue";
import FriendsNowPlayingList from "../components/Friends/FriendsNowPlayingList.vue";
import FriendsNewAdd from "../components/Friends/FriendsNewAdd.vue";

export default {
  components: {
    FriendsSideBar,
    UserSection,
    FriendsStateMenuBar,
    FriendsStateList,
    FriendsNowPlayingList,
    FriendsNewAdd,
  },
  created() {
    const msg = {
      user_id: this.getUserId,
      channel_id: "home",
      type: "state",
    };
    this.stompSocketClient.send("/kafka/join-channel", JSON.stringify(msg), {});
  },
  computed: {
    ...mapState("friends", ["friendsStateMenu"]),
    ...mapState("utils", ["stompSocketClient", "stompSocketConnected"]),
    ...mapGetters("user", ["getEmail", "getUserId", "getAccessToken"]),
  },
};
</script>

<style>
.content-mypage {
  display: flex;
  -webkit-box-align: stretch;
  align-items: stretch;
  -webkit-box-pack: start;
  justify-content: flex-start;
  min-width: 0;
  min-height: 0;
  -webkit-box-flex: 1;
  flex: 1 1 auto;
}
.sidebar {
  display: flex;
  flex-direction: column;
  min-height: 0;
  width: 240px;
  -webkit-box-flex: 0;
  flex: 0 0 auto;
  background: #2f3136;
  overflow: hidden;
}
.dm-scroller {
  overflow: hidden scroll;
  padding-right: 0px;
  background-color: #2f3136;
}
.thin-scrollbar::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}
.thin-scrollbar::-webkit-scrollbar-corner {
  background-color: #00000000;
}
.thin-scrollbar::-webkit-scrollbar-thumb {
  background-clip: padding-box;
  border: 2px solid #00000000;
  border-radius: 4px;
  background-color: var(--dark-grey-color);
  min-height: 40px;
}
.thin-scrollbar::-webkit-scrollbar-track {
  border-color: #00000000;
  background-color: #00000000;
  border: 2px solid #00000000;
}

.friends-state-container {
  background-color: #36393f;
  display: flex;
  width: 100%;
  overflow: hidden;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  flex-direction: column;
}

.friends-state-container2 {
  height: 100%;
  -webkit-box-orient: horizontal;
  -webkit-box-direction: normal;
  flex-direction: row;
  position: relative;
  overflow: hidden;
  transform: translateZ(0);
  display: flex;
}
</style>
