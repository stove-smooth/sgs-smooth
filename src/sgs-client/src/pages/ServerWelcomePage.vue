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
import { mapActions, mapState } from "vuex";
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
  methods: {
    ...mapActions("server", ["FETCH_COMMUNITYINFO"]),
    async fetchCommunityInfo() {
      console.log(this.$route.params.serverid);
      await this.FETCH_COMMUNITYINFO(this.$route.params.serverid);
    },
  },
  computed: {
    ...mapState("server", ["communityInfo"]),
  },
  watch: {
    // 라우터의 변경을 감시
    /*     $route(to, from) {
      if (to.path != from.path) {
        console.log(to.path, from.path);
        this.fetchCommunityInfo();
        console.log("있나?", this.communityInfo);
      }
    }, */
  },
  async created() {
    await this.fetchCommunityInfo();
    const firstchannel = this.communityInfo.categories[0].channels[0].id;
    if (firstchannel) {
      this.$router.push(
        "/channels/" + this.$route.params.serverid + "/" + firstchannel
      );
    }
  },
};
</script>

<style></style>
