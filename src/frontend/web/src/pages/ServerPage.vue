<template>
  <div class="base-container">
    <div class="content-mypage" :key="$route.params.channelid">
      <div class="sidebar">
        <server-side-bar />
        <user-section />
      </div>
      <div class="server-activity-container">
        <template v-if="isChattingChannel($route.params.channelid)">
          <server-chatting-menu-bar />
          <div class="server-activity-container1">
            <server-activity-area />
            <server-member-list />
          </div>
        </template>
        <template v-else>
          <template v-if="wsOpen"
            ><div class="voice-sharing-container flex-direction-column">
              <server-chatting-menu-bar />
              <div class="server-activity-container1">
                <voice-sharing-area />
                <server-member-list />
              </div></div
          ></template>
        </template>
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions, mapState, mapMutations } from "vuex";
import ServerSideBar from "../components/Community/Community/ServerSideBar.vue";
import UserSection from "../components/common/UserSection.vue";
import ServerChattingMenuBar from "../components/Community/Community/ServerChattingMenuBar.vue";
import ServerActivityArea from "../components/Community/Community/ServerActivityArea.vue";
import ServerMemberList from "../components/Community/Community/ServerMemberList.vue";
import VoiceSharingArea from "../components/common/Voice/VoiceSharingArea.vue";
export default {
  components: {
    ServerSideBar,
    UserSection,
    ServerChattingMenuBar,
    ServerActivityArea,
    ServerMemberList,
    VoiceSharingArea,
  },
  async created() {
    await this.fetchCommunityInfo();
  },
  methods: {
    ...mapActions("server", [
      "FETCH_COMMUNITYINFO",
      "FETCH_COMMUNITYMEMBERLIST",
    ]),
    ...mapMutations("server", ["setCurrentChannelType"]),
    async fetchCommunityInfo() {
      await this.FETCH_COMMUNITYINFO(this.$route.params.serverid);
      await this.FETCH_COMMUNITYMEMBERLIST(this.$route.params.serverid);
    },
    isChattingChannel(channelId) {
      const categories = this.communityInfo.categories;
      for (var category in categories) {
        if (categories[category].channels != null) {
          for (let i = 0; i < categories[category].channels.length; i++) {
            if (categories[category].channels[i].id == channelId) {
              if (categories[category].channels[i].type == "TEXT") {
                this.setCurrentChannelType("TEXT");
                return true;
              } else {
                this.setCurrentChannelType("VOICE");
                return false;
              }
            }
          }
        }
      }
    },
  },
  computed: {
    ...mapState("server", ["communityInfo"]),
    ...mapState("voice", ["wsOpen"]),
  },
};
</script>

<style>
.base-container {
  display: flex;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  overflow: hidden;
  flex-direction: column;
  position: relative;
  -webkit-box-flex: 1;
  flex-grow: 1;
}
.server-activity-container {
  -webkit-box-flex: 1;
  flex: 1 1 auto;
  min-width: 0;
  min-height: 0;
  display: flex;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  flex-direction: column;
  position: relative;
  overflow: hidden;
  background: #36393f;
}
.server-activity-container1 {
  min-width: 0;
  min-height: 0;
  -webkit-box-flex: 1;
  flex: 1 1 auto;
  display: flex;
  -webkit-box-orient: horizontal;
  -webkit-box-direction: normal;
  flex-direction: row;
  justify-content: stretch;
  -webkit-box-align: stretch;
  align-items: stretch;
  position: relative;
}
</style>
