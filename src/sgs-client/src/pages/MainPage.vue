<template>
  <div>
    <!-- <template v-if="this.stompSocketConnected"> -->
    <div class="wrapper2">
      <div class="wrapper">
        <div class="container">
          <navigation-bar v-if="navbar"></navigation-bar>
          <router-view></router-view>
        </div>
      </div>
    </div>
    <server-popout></server-popout>
    <friends-plus-action></friends-plus-action>
    <message-plus-action></message-plus-action>
    <create-server-modal></create-server-modal>
    <create-channel-modal></create-channel-modal>
    <friends-delete-modal></friends-delete-modal>
    <friends-block-modal></friends-block-modal>
    <friends-profile-modal></friends-profile-modal>
    <create-category-modal></create-category-modal>
    <category-setting-modal></category-setting-modal>
    <category-delete-modal></category-delete-modal>
    <server-setting-modal></server-setting-modal>
    <template v-if="communityInviteModal">
      <invite-community-modal></invite-community-modal>
    </template>

    <channel-setting-modal></channel-setting-modal>
    <community-delete-modal></community-delete-modal>
    <channel-delete-modal></channel-delete-modal>
    <!-- </template> -->
    <!-- <template v-else> <loading-spinner /> </template> -->
  </div>
</template>

<script>
import Stomp from "webstomp-client";
import SockJS from "sockjs-client";
import { mapGetters, mapMutations, mapState } from "vuex";
//import LoadingSpinner from "@/components/common/LoadingSpinner.vue";
import NavigationBar from "../components/NavigationBar.vue";
import CreateServerModal from "../components/CreateServerModal.vue";
import CreateChannelModal from "../components/CreateChannelModal.vue";
import FriendsPlusAction from "../components/common/FriendsPlusAction.vue";
import FriendsDeleteModal from "../components/FriendsDeleteModal.vue";
import ServerPopout from "../components/ServerPopout.vue";
import FriendsBlockModal from "../components/FriendsBlockModal.vue";
import FriendsProfileModal from "../components/FriendsProfileModal.vue";
import CreateCategoryModal from "../components/CreateCategoryModal.vue";
import CategorySettingModal from "../components/CategorySettingModal.vue";
import CategoryDeleteModal from "../components/CategoryDeleteModal.vue";
import ServerSettingModal from "../components/ServerSettingModal.vue";
import MessagePlusAction from "../components/MessagePlusAction.vue";
import InviteCommunityModal from "../components/InviteCommunityModal.vue";
import ChannelSettingModal from "../components/ChannelSettingModal.vue";
import CommunityDeleteModal from "../components/CommunityDeleteModal.vue";
import ChannelDeleteModal from "../components/ChannelDeleteModal.vue";

export default {
  name: "App",
  components: {
    NavigationBar,
    CreateServerModal,
    CreateChannelModal,
    FriendsPlusAction,
    FriendsDeleteModal,
    ServerPopout,
    FriendsBlockModal,
    FriendsProfileModal,
    CreateCategoryModal,
    CategorySettingModal,
    CategoryDeleteModal,
    ServerSettingModal,
    //LoadingSpinner,
    MessagePlusAction,
    InviteCommunityModal,
    ChannelSettingModal,
    CommunityDeleteModal,
    ChannelDeleteModal,
  },
  data() {
    return {
      navbar: true,
    };
  },
  created() {
    if (this.getEmail) {
      this.connect();
    }
    const url = window.location.pathname;
    if (url == "/settings") {
      this.navbar = false;
    } else {
      this.navbar = true;
    }
  },
  watch: {
    // 라우터의 변경을 감시
    $route(to, from) {
      if (to.path != from.path) {
        if (to.path === "/settings") {
          this.navbar = false;
        } else {
          this.navbar = true;
        }
      }
    },
  },
  computed: {
    ...mapState("utils", ["stompSocketClient", "stompSocketConnected"]),
    ...mapGetters("user", ["getEmail", "getUserId", "getAccessToken"]),
    ...mapState("server", ["communityInviteModal"]),
  },
  methods: {
    ...mapMutations("utils", [
      "setStompSocketClient",
      "setStompSocketConnected",
    ]),
    connect() {
      const serverURL = process.env.VUE_APP_BASE_URL + "my-chat";
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
  },
};
</script>

<style>
@import "../css/common.css";
.wrapper2 {
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  background-color: var(--dark-grey-color);
  display: flex;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  flex-direction: column;
}
.container {
  position: relative;
  overflow: hidden;
  width: 100%;
  height: 100%;
  display: flex;
}
button {
  font-weight: 500;
  border: 0;
  cursor: pointer;
}
a img {
  border: none;
}
</style>
