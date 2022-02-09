<template>
  <div class="base-container">
    <div class="content-mypage">
      <template v-if="computed">
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
      </template>
      <template v-else><loading-spinner></loading-spinner></template>
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
import LoadingSpinner from "../components/common/LoadingSpinner.vue";
export default {
  components: {
    ServerSideBar,
    UserSection,
    ServerChattingMenuBar,
    ServerMemberList,
    ServerWelcome,
    LoadingSpinner,
  },
  data() {
    return {
      computed: false,
    };
  },
  methods: {
    ...mapActions("server", ["FETCH_COMMUNITYINFO"]),
    async fetchCommunityInfo() {
      await this.FETCH_COMMUNITYINFO(this.$route.params.serverid);
    },
    computeFirstChannel() {
      const categories = this.communityInfo.categories;
      for (var category in categories) {
        if (categories[category].channels != null) {
          for (var channels in categories[category].channels) {
            if (categories[category].channels[channels].type === "TEXT") {
              const firstchannel = categories[category].channels[channels].id;
              this.$router.push(
                "/channels/" + this.$route.params.serverid + "/" + firstchannel
              );
              this.computed = true;
            }
          }
        }
      }
      this.computed = true;
    },
  },
  computed: {
    ...mapState("server", ["communityInfo"]),
  },
  watch: {
    // 라우터의 변경을 감시
    async $route(to, from) {
      if (to.path != from.path) {
        await this.fetchCommunityInfo();
        this.computeFirstChannel();
      }
    },
  },
  async created() {
    await this.fetchCommunityInfo();
    this.computeFirstChannel();
  },
};
</script>

<style></style>
