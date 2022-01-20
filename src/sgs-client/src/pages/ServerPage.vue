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
          <server-activity-area></server-activity-area>
          <server-member-list></server-member-list>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions } from "vuex";
import ServerSideBar from "../components/ServerSideBar.vue";
import UserSection from "../components/common/UserSection.vue";
import ServerChattingMenuBar from "../components/ServerChattingMenuBar.vue";
import ServerActivityArea from "../components/ServerActivityArea.vue";
import ServerMemberList from "../components/ServerMemberList.vue";
export default {
  components: {
    ServerSideBar,
    UserSection,
    ServerChattingMenuBar,
    ServerActivityArea,
    ServerMemberList,
  },
  methods: {
    ...mapActions("server", [
      "FETCH_COMMUNITYINFO",
      "FETCH_COMMUNITYMEMBERLIST",
    ]),
    async fetchCommunityInfo() {
      await this.FETCH_COMMUNITYINFO(this.$route.params.serverid);
      await this.FETCH_COMMUNITYMEMBERLIST(this.$route.params.serverid);
    },
  },
  async created() {
    await this.fetchCommunityInfo();
  },
};
</script>

<style>
.base-container {
  /* display: -webkit-box;
  display: -ms-flexbox; */
  display: flex;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  /* -ms-flex-direction: column; */
  overflow: hidden;
  flex-direction: column;
  position: relative;
  -webkit-box-flex: 1;
  /* -ms-flex-positive: 1; */
  flex-grow: 1;
}
.server-activity-container {
  -webkit-box-flex: 1;
  /* -ms-flex: 1 1 auto; */
  flex: 1 1 auto;
  min-width: 0;
  min-height: 0;
  /* display: -webkit-box;
  display: -ms-flexbox; */
  display: flex;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  /* -ms-flex-direction: column; */
  flex-direction: column;
  position: relative;
  overflow: hidden;
  background: #36393f;
}
.server-activity-container1 {
  min-width: 0;
  min-height: 0;
  -webkit-box-flex: 1;
  /*  -ms-flex: 1 1 auto; */
  flex: 1 1 auto;
  /* display: -webkit-box;
  display: -ms-flexbox; */
  display: flex;
  -webkit-box-orient: horizontal;
  -webkit-box-direction: normal;
  /* -ms-flex-direction: row; */
  flex-direction: row;
  /* -webkit-box-pack: stretch; */
  /* -ms-flex-pack: stretch; */
  justify-content: stretch;
  -webkit-box-align: stretch;
  /* -ms-flex-align: stretch; */
  align-items: stretch;
  position: relative;
}
</style>
