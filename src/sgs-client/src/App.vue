<template>
  <div>
    <div class="wrapper2">
      <div class="wrapper">
        <div class="container">
          <navigation-bar v-if="getEmail && navbar"></navigation-bar>
          <router-view></router-view>
        </div>
      </div>
    </div>
    <server-popout></server-popout>
    <friends-plus-action></friends-plus-action>
    <create-server-modal></create-server-modal>
    <create-channel-modal></create-channel-modal>
    <friends-delete-modal></friends-delete-modal>
    <friends-block-modal></friends-block-modal>
    <friends-profile-modal></friends-profile-modal>
    <create-category-modal></create-category-modal>
    <category-setting-modal></category-setting-modal>
    <category-delete-modal></category-delete-modal>
    <server-setting-modal></server-setting-modal>
  </div>
</template>

<script>
import Stomp from "webstomp-client";
import SockJS from "sockjs-client";
import NavigationBar from "./components/NavigationBar.vue";
import CreateServerModal from "./components/CreateServerModal.vue";
import CreateChannelModal from "./components/CreateChannelModal.vue";
import { mapGetters, mapState, mapMutations } from "vuex";
import FriendsPlusAction from "./components/common/FriendsPlusAction.vue";
import FriendsDeleteModal from "./components/FriendsDeleteModal.vue";
import ServerPopout from "./components/ServerPopout.vue";
import FriendsBlockModal from "./components/FriendsBlockModal.vue";
import FriendsProfileModal from "./components/FriendsProfileModal.vue";
import CreateCategoryModal from "./components/CreateCategoryModal.vue";
import CategorySettingModal from "./components/CategorySettingModal.vue";
import CategoryDeleteModal from "./components/CategoryDeleteModal.vue";
import ServerSettingModal from "./components/ServerSettingModal.vue";

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
  },
  data() {
    return {
      navbar: true,
    };
  },
  created() {
    this.connect();
    const url = window.location.pathname;
    if (url == "/settings" || url == "/login" || url == "/register") {
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
  methods: {
    ...mapMutations("utils", [
      "setStompSocketClient",
      "setStompSocketConnected",
    ]),
    connect() {
      const serverURL = "http://52.79.229.100:8000/my-chat";
      let socket = new SockJS(serverURL);
      this.setStompSocketClient(Stomp.over(socket));
      console.log(`소켓 연결을 시도합니다. 서버 주소: ${serverURL}`);
      this.stompSocketClient.connect(
        {
          "access-token":
            "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJwYWs3MzgwQG5hdmVyLmNvbSIsInJvbGUiOiJST0xFX0FETUlOIiwiaWQiOjIsImlhdCI6MTY0MjQ3MDUxMCwiZXhwIjoxNjUxMTEwNTEwfQ.9BPJb78q4GUiLX3pMcUhlT4wDR-sx3tdu8RodYNwkfk",
          "user-id": "1",
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
  computed: {
    ...mapGetters("user", ["getEmail"]),
    ...mapState("utils", ["stompSocketClient", "stompSocketConnected"]),
  },
};
</script>

<style>
@import "./css/common.css";
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
