<template>
  <div class="base-container">
    <div class="content-mypage" :key="$route.params.channelid">
      <div class="sidebar">
        <community-side-bar />
        <user-section />
      </div>
      <div class="server-activity-container">
        <template v-if="isChattingChannel($route.params.channelid)">
          <community-chatting-menu-bar />
          <div class="server-activity-container1">
            <community-activity-area />
            <community-member-list />
          </div>
        </template>
        <template v-else>
          <template v-if="wsOpen && currentVoiceRoomType == 'community'"
            ><div class="voice-sharing-container flex-direction-column">
              <community-chatting-menu-bar />
              <div class="server-activity-container1">
                <voice-sharing-area />
                <community-member-list />
              </div></div
          ></template>
        </template>
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions, mapState, mapMutations } from "vuex";
import CommunitySideBar from "../components/Community/Community/CommunitySideBar.vue";
import UserSection from "../components/common/UserSection.vue";
import CommunityChattingMenuBar from "../components/Community/Community/CommunityChattingMenuBar.vue";
import CommunityActivityArea from "../components/Community/Community/CommunityActivityArea.vue";
import CommunityMemberList from "../components/Community/Community/CommunityMemberList.vue";
import VoiceSharingArea from "../components/common/Voice/VoiceSharingArea.vue";
export default {
  components: {
    CommunitySideBar,
    UserSection,
    CommunityChattingMenuBar,
    CommunityActivityArea,
    CommunityMemberList,
    VoiceSharingArea,
  },
  async created() {
    await this.fetchCommunityInfo();
    this.stompSocketClient.subscribe(
      `/topic/community/${this.$route.params.serverid}`,
      (res) => {
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
    );
  },
  methods: {
    ...mapActions("community", ["FETCH_COMMUNITYINFO"]),
    ...mapMutations("community", ["setCurrentChannelType"]),
    async fetchCommunityInfo() {
      await this.FETCH_COMMUNITYINFO(this.$route.params.serverid);
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
    ...mapState("community", ["communityInfo"]),
    ...mapState("voice", ["wsOpen", "currentVoiceRoomType"]),
    ...mapState("utils", ["stompSocketClient"]),
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
