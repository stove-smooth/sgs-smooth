<template>
  <div class="base-container">
    <div class="content-mypage">
      <div class="sidebar">
        <server-side-bar></server-side-bar>
        <user-section></user-section>
      </div>
      <div class="server-activity-container">
        <server-chatting-menu-bar></server-chatting-menu-bar>
        <div class="server-activity-container1">
          <server-welcome></server-welcome>
          <server-member-list></server-member-list>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import ServerSideBar from "../components/ServerSideBar.vue";
import UserSection from "../components/common/UserSection.vue";
import ServerChattingMenuBar from "../components/ServerChattingMenuBar.vue";
import ServerMemberList from "../components/ServerMemberList.vue";
import ServerWelcome from "../components/ServerWelcome.vue";
export default {
  components: {
    ServerSideBar,
    UserSection,
    ServerChattingMenuBar,
    ServerMemberList,
    ServerWelcome,
  },
};
</script>

<style></style>
