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
    computeFirstChannel() {
      for (var category in this.communityInfo.categories) {
        console.log(this.communityInfo.categories[category]);
        if (this.communityInfo.categories[category].channels != null) {
          const firstchannel =
            this.communityInfo.categories[category].channels[0].id;
          console.log("첫번째 채널: : ", firstchannel);
          if (firstchannel) {
            this.$router.push(
              "/channels/" + this.$route.params.serverid + "/" + firstchannel
            );
          }
          return true;
        }
      }
      return false;
    },
  },
  computed: {
    ...mapState("server", ["communityInfo"]),
  },
  watch: {
    // 라우터의 변경을 감시
    async $route(to, from) {
      if (to.path != from.path) {
        console.log(to.path, from.path);
        await this.fetchCommunityInfo();
        const result = this.computeFirstChannel();
        if (!result) {
          console.log("채널없음");
        }
      }
    },
  },
  async created() {
    await this.fetchCommunityInfo();
    const result = this.computeFirstChannel();
    if (!result) {
      console.log("채널없음");
    }
    /* const firstchannel = this.communityInfo.categories[0].channels[0].id;
    console.log("첫번째채널", firstchannel);
    if (firstchannel) {
      this.$router.push(
        "/channels/" + this.$route.params.serverid + "/" + firstchannel
      );
    } */
  },
};
</script>

<style></style>
