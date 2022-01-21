<template>
  <div class="layer">
    <div class="content-mypage">
      <div class="sidebar">
        <friends-side-bar></friends-side-bar>
        <user-section></user-section>
      </div>
      <div class="friends-state-container">
        <friends-state-menu-bar></friends-state-menu-bar>
        <div class="friends-state-container2">
          <template v-if="friendsStateMenu === 'addfriends'">
            <friends-new-add></friends-new-add>
          </template>
          <template v-else>
            <friends-state-list></friends-state-list>
          </template>
          <friends-now-playing-list></friends-now-playing-list>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
/* import Stomp from "webstomp-client";
import SockJS from "sockjs-client"; */
import { mapGetters, mapState } from "vuex";
/* import { getBaseURL } from "../utils/common"; */

import FriendsSideBar from "../components/FriendsSideBar.vue";
import FriendsStateList from "../components/FriendsStateList.vue";
import FriendsStateMenuBar from "../components/FriendsStateMenuBar.vue";
import UserSection from "../components/common/UserSection.vue";
import FriendsNowPlayingList from "../components/FriendsNowPlayingList.vue";
import FriendsNewAdd from "../components/FriendsNewAdd.vue";

export default {
  components: {
    FriendsSideBar,
    UserSection,
    FriendsStateMenuBar,
    FriendsStateList,
    FriendsNowPlayingList,
    FriendsNewAdd,
  },
  computed: {
    ...mapState("friends", ["friendsStateMenu"]),
    ...mapState("utils", ["stompSocketClient", "stompSocketConnected"]),
    ...mapGetters("user", ["getEmail", "getUserId", "getAccessToken"]),
  },
  /*  created() {
    if (this.getEmail) {
      this.connect();
    }
  }, */
  /* methods: {
    ...mapMutations("utils", [
      "setStompSocketClient",
      "setStompSocketConnected",
    ]),
    connect() {
      const serverURL = getBaseURL() + "my-chat";
      let socket = new SockJS(serverURL);
      this.setStompSocketClient(Stomp.over(socket));
      console.log(`소켓 연결을 시도합니다. 서버 주소: ${serverURL}`);
      this.stompSocketClient.connect(
        {
          "access-token": this.getAccessToken,
          "user-id": this.getUserId,
        }, //header
        (frame) => {
          // 소켓 연결 성공
          this.connected = true;
          this.setStompSocketConnected(true);
          console.log("소켓 연결 성공", frame);
        },
        (error) => {
          // 소켓 연결 실패
          console.log("소켓 연결 실패", error);
          this.connected = false;
          this.setStompSocketConnected(false);
        }
      );
    },
  }, */
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
  /*   -ms-flex: 0 0 auto; */
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
  /*  -ms-flex-direction: column; */
  flex-direction: column;
}

.friends-state-container2 {
  height: 100%;
  -webkit-box-orient: horizontal;
  -webkit-box-direction: normal;
  /* -ms-flex-direction: row; */
  flex-direction: row;
  position: relative;
  overflow: hidden;
  /* -webkit-transform: translateZ(0); */
  transform: translateZ(0);
  display: flex;
}
</style>
