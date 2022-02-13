<template>
  <div class="base-container">
    <div class="content-mypage" :key="$route.params.serverid">
      <template v-if="computed">
        <div class="sidebar">
          <community-side-bar />
          <user-section />
        </div>
        <div class="server-activity-container">
          <community-chatting-menu-bar />
          <div class="server-activity-container1">
            <community-welcome />
            <community-member-list />
          </div>
        </div>
      </template>
      <template v-else><loading-spinner /></template>
    </div>
  </div>
</template>

<script>
import { mapActions, mapState, mapGetters } from "vuex";
import CommunitySideBar from "../components/Community/Community/CommunitySideBar.vue";
import UserSection from "../components/common/UserSection.vue";
import CommunityChattingMenuBar from "../components/Community/Community/CommunityChattingMenuBar.vue";
import CommunityMemberList from "../components/Community/Community/CommunityMemberList.vue";
import CommunityWelcome from "../components/Community/Community/CommunityWelcome.vue";
import LoadingSpinner from "../components/common/LoadingSpinner.vue";
export default {
  components: {
    CommunitySideBar,
    UserSection,
    CommunityChattingMenuBar,
    CommunityMemberList,
    CommunityWelcome,
    LoadingSpinner,
  },
  data() {
    return {
      computed: false,
    };
  },
  methods: {
    ...mapActions("community", ["FETCH_COMMUNITYINFO"]),
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
              return;
            }
          }
        }
      }
      this.computed = true;
      //communitywelcomepage진입시 home으로 상태 판단
      const msg = {
        user_id: this.getUserId,
        channel_id: "home",
        type: "state",
      };
      this.stompSocketClient.send(
        "/kafka/join-channel",
        JSON.stringify(msg),
        {}
      );
    },
  },
  computed: {
    ...mapState("community", ["communityInfo"]),
    ...mapState("utils", ["stompSocketClient"]),
    ...mapGetters("user", ["getUserId"]),
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
    /* this.stompSocketClient.subscribe(
      `/topic/community/${this.$route.params.serverid}`,
      async (res) => {
        console.log("시그널링 서버 상태 구독입니다", res.body);
      }
    );
    const msg = {
      user_id: this.getUserId,
      community_id: this.$route.params.serverid,
      type: "before-enter",
    };
    this.stompSocketClient.send(
      "/kafka/community-signaling",
      JSON.stringify(msg),
      {}
    ); */
    this.computeFirstChannel();
  },
};
</script>

<style></style>
