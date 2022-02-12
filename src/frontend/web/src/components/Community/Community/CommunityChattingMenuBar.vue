<template>
  <section class="primary-header">
    <div class="header-children-wrapper">
      <div class="primary-icon-wrapper">
        <svg v-if="channelName" class="hashtag-icon"></svg>
      </div>
      <h3 class="server-name" aria-label="channel-name">{{ channelName }}</h3>
    </div>
    <div class="primary-header-toolbar">
      <div class="server-chatting-searchbar"><search-bar></search-bar></div>
    </div>
  </section>
</template>

<script>
import { computeChannelName } from "../../../utils/common.js";
import SearchBar from "../../common/SearchBar.vue";
import { mapState, mapMutations } from "vuex";
export default {
  components: {
    SearchBar,
  },
  methods: {
    ...mapMutations("server", ["setOpenFixedMessagesModal"]),
  },
  computed: {
    ...mapState("server", ["communityInfo"]),
    channelName() {
      let channel = computeChannelName(
        this.$route.params.channelid,
        this.communityInfo
      );
      return channel;
    },
  },
};
</script>

<style>
.thread-icon {
  display: flex;
  width: 24px;
  height: 24px;
  background-image: url("../../../assets/thread-icon.svg");
}
.big-alarms-icon {
  display: flex;
  width: 20px;
  height: 20px;
  background-image: url("../../../assets/big-alarms.svg");
}
.fixed-icon {
  width: 20px;
  height: 20px;
  background-image: url("../../../assets/fixed.svg");
}
.server-chatting-searchbar {
  width: 240px;
}
</style>
