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
    <user-profile-modal></user-profile-modal>
  </div>
</template>

<script>
import NavigationBar from "./components/NavigationBar.vue";
import CreateServerModal from "./components/CreateServerModal.vue";
import CreateChannelModal from "./components/CreateChannelModal.vue";
import { mapGetters } from "vuex";
import FriendsPlusAction from "./components/common/FriendsPlusAction.vue";
import FriendsDeleteModal from "./components/FriendsDeleteModal.vue";
import ServerPopout from "./components/ServerPopout.vue";
import FriendsBlockModal from "./components/FriendsBlockModal.vue";
import UserProfileModal from "./components/UserProfileModal.vue";
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
    UserProfileModal,
  },
  data() {
    return {
      navbar: true,
    };
  },
  created() {
    console.log(window.location.pathname);
    const currentUrl = window.location.pathname;
    if (
      currentUrl == "/settings" ||
      currentUrl == "/login" ||
      currentUrl == "/register"
    ) {
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
    ...mapGetters("auth", ["getEmail"]),
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
