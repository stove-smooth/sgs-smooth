<template>
  <div>
    <template v-if="this.stompSocketConnected">
      <div class="wrapper2">
        <div class="wrapper">
          <div
            class="container"
            :key="
              $route.params.serverid ? $route.params.serverid : $route.params.id
            "
          >
            <navigation-bar v-if="navbar"></navigation-bar>
            <router-view></router-view>
          </div>
        </div>
      </div>
      <community-popout />
      <friends-plus-action />
      <message-plus-action />
      <create-community-modal />
      <create-channel-modal />
      <friends-delete-modal />
      <friends-block-modal />
      <friends-profile-modal />
      <create-category-modal />
      <category-setting-modal />
      <category-delete-modal />
      <community-setting-modal />
      <template v-if="communityInviteModal">
        <invite-community-modal />
      </template>
      <channel-setting-modal />
      <community-delete-modal />
      <channel-delete-modal />
      <community-exit-modal />
      <fix-message-modal />
      <fixed-messages-modal />
      <community-members-plus-action />
      <community-banish-modal />
      <create-direct-message-group-modal />
    </template>
    <template v-else> <loading-spinner /> </template>
  </div>
</template>

<script>
import Stomp from "webstomp-client";
import SockJS from "sockjs-client";

import { mapGetters, mapMutations, mapState } from "vuex";
import LoadingSpinner from "@/components/common/LoadingSpinner.vue";
import NavigationBar from "../components/NavigationBar.vue";
import CreateCommunityModal from "../components/Community/Community/CreateCommunityModal.vue";
import CreateChannelModal from "../components/Community/Channel/CreateChannelModal.vue";
import FriendsPlusAction from "../components/Friends/FriendsPlusAction.vue";
import FriendsDeleteModal from "../components/Friends/FriendsDeleteModal.vue";
import CommunityPopout from "../components/Community/Community/CommunityPopout.vue";
import FriendsBlockModal from "../components/Friends/FriendsBlockModal.vue";
import FriendsProfileModal from "../components/Friends/FriendsProfileModal.vue";
import CreateCategoryModal from "../components/Community/Category/CreateCategoryModal.vue";
import CategorySettingModal from "../components/Community/Category/CategorySettingModal.vue";
import CategoryDeleteModal from "../components/Community/Category/CategoryDeleteModal.vue";
import CommunitySettingModal from "../components/Community/Community/CommunitySettingModal.vue";
import MessagePlusAction from "../components/common/Message/MessagePlusAction.vue";
import InviteCommunityModal from "../components/Community/Community/InviteCommunityModal.vue";
import ChannelSettingModal from "../components/Community/Channel/ChannelSettingModal.vue";
import CommunityDeleteModal from "../components/Community/Community/CommunityDeleteModal.vue";
import ChannelDeleteModal from "../components/Community/Channel/ChannelDeleteModal.vue";
import CommunityExitModal from "../components/Community/Community/CommunityExitModal.vue";
import FixMessageModal from "../components/common/Message/FixMessageModal.vue";
import FixedMessagesModal from "../components/common/Message/FixedMessagesModal.vue";
import CommunityMembersPlusAction from "../components/Community/Community/CommunityMembersPlusAction.vue";
import CommunityBanishModal from "../components/Community/Community/CommunityBanishModal.vue";
import CreateDirectMessageGroupModal from "../components/DM/CreateDirectMessageGroupModal.vue";

export default {
  name: "App",
  components: {
    NavigationBar,
    CreateCommunityModal,
    CreateChannelModal,
    FriendsPlusAction,
    FriendsDeleteModal,
    CommunityPopout,
    FriendsBlockModal,
    FriendsProfileModal,
    CreateCategoryModal,
    CategorySettingModal,
    CategoryDeleteModal,
    CommunitySettingModal,
    LoadingSpinner,
    MessagePlusAction,
    InviteCommunityModal,
    ChannelSettingModal,
    CommunityDeleteModal,
    ChannelDeleteModal,
    CommunityExitModal,
    FixMessageModal,
    FixedMessagesModal,
    CommunityMembersPlusAction,
    CommunityBanishModal,
    CreateDirectMessageGroupModal,
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
    ...mapState("voice", ["ws"]),
    ...mapGetters("user", [
      "getEmail",
      "getUserId",
      "getAccessToken",
      "getSocketUrl",
    ]),
    ...mapState("community", ["communityInviteModal"]),
  },
  methods: {
    ...mapMutations("utils", [
      "setStompSocketClient",
      "setStompSocketConnected",
    ]),
    connect() {
      const serverURL = this.getSocketUrl + "/my-chat";
      let socket = new SockJS(serverURL);
      this.setStompSocketClient(Stomp.over(socket));
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
</style>
