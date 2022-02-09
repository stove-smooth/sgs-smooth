<template>
  <div class="private-channels">
    <div class="searchbar-container">
      <button class="searchbar">대화 찾기 또는 시작하기</button>
    </div>
    <div class="thin-scrollbar dm-scroller">
      <div class="side-content">
        <div class="primary-member-container">
          <div
            class="primary-member-layout"
            @click="routeMypage"
            v-bind:class="{
              'primary-member-layout-hover':
                navigationSelected == '@me' && !this.$route.params.id,
            }"
          >
            <div class="avatar-container">
              <svg class="friends-icon"></svg>
            </div>
            <div class="friends-contents">
              <div class="friends-name-decorator">
                <div class="friends-name">친구</div>
              </div>
            </div>
            <div class="friends-alarm-wrapper" v-show="friendsWaitNumber">
              <number-badge :alarms="friendsWaitNumber"></number-badge>
            </div>
          </div>
        </div>
        <h2 class="private-channels-header-container small-title-text">
          <span class="private-channels-header-text">다이렉트 메시지</span>
          <div class="invite-private-channels-button" aria-label="DM생성">
            <svg class="invite-private-channels-icon"></svg>
          </div>
        </h2>
        <dm-list-form></dm-list-form>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapActions } from "vuex";
import NumberBadge from "./common/NumberBadge.vue";
import DmListForm from "./DMListForm.vue";
export default {
  components: { DmListForm, NumberBadge },
  async created() {
    await this.fetchDirectMessageList();
  },
  computed: {
    ...mapState("friends", ["friendsWaitNumber"]),
    ...mapState("utils", ["navigationSelected"]),
  },
  methods: {
    ...mapActions("dm", ["fetchDirectMessageList"]),
    routeMypage() {
      this.$router.push("/channels/@me");
    },
  },
};
</script>
<style>
.private-channels {
  box-sizing: border-box;
  overflow: hidden;
  user-select: none;
  -webkit-box-flex: 1;
  flex: 1;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  flex-direction: column;
  background-color: #2f3136;
  position: relative;
  display: flex;
}
.searchbar-container {
  z-index: 2;
  -webkit-box-flex: 0;
  flex: 0 0 auto;
  padding: 10px 10px 0px 10px;
  height: 48px;
  -webkit-box-align: center;
  align-items: center;
  box-shadow: 0 1px 0 rgba(4, 4, 5, 0.2), 0 1.5px 0 rgba(6, 6, 7, 0.05),
    0 2px 0 rgba(4, 4, 5, 0.05);
}
.searchbar {
  width: 100%;
  height: 28px;
  overflow: hidden;
  border-radius: 4px;
  background-color: var(--dark-grey-color);
  box-shadow: none;
  color: #72767d;
  text-align: left;
  text-overflow: ellipsis;
  font-size: 14px;
  font-weight: 500;
  line-height: 24px;
  white-space: nowrap;
}
.side-content {
  position: relative;
  padding-top: 8px;
}

.avatar-container {
  display: flex;
  -webkit-box-align: center;
  align-items: center;
  -webkit-box-pack: center;
  justify-content: center;
  -webkit-box-flex: 0;
  flex: 0 0 auto;
  width: 32px;
  height: 32px;
  margin-right: 12px;
}
.friends-icon {
  display: flex;
  width: 21px;
  height: 17px;
  background-image: url("../assets/friends.svg");
}
.friends-contents {
  min-width: 0;
  -webkit-box-flex: 1;
  flex: 1 1 auto;
}
.friends-name-decorator {
  display: flex;
  -webkit-box-pack: start;
  justify-content: space-between;
  -webkit-box-align: center;
  align-items: center;
}
.friends-name {
  font-size: 16px;
  line-height: 20px;
  font-weight: 500;
  -webkit-box-flex: 0;
  flex: 0 1 auto;
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
}
.private-channels-header-container {
  display: flex;
  padding: 18px 8px 4px 18px;
  height: 40px;
}

.small-title-text {
  box-sizing: border-box;
  text-overflow: ellipsis;
  white-space: nowrap;
  overflow: hidden;
  text-transform: uppercase;
  font-size: 12px;
  line-height: 16px;
  letter-spacing: 0.25px;
  font-weight: 600;
  -webkit-box-flex: 1;
  flex: 1 1 auto;
  color: #8e9297;
}

.private-channels-header-text {
  -webkit-box-flex: 1;
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
}
.invite-private-channels-button {
  -webkit-box-flex: 0;
  flex: 0;
  width: 16px;
  height: 16px;
  margin-left: 0;
  margin-right: 2px;
  position: relative;
  margin: 0 8px;
  cursor: pointer;
}
.invite-private-channels-icon {
  width: 12px;
  height: 12px;
  margin-left: 0;
  margin-right: 2px;
  background-image: url("../assets/private-channel-plus.svg");
}

.avatar-wrapper {
  display: relative;
  width: 100%;
  height: 100%;
}
.avatar {
  display: block;
  object-fit: cover;
  pointer-events: none;
  width: 100%;
  height: 100%;
  grid-area: 1/1;
  border-radius: 50%;
}
.subtext-decorator {
  margin-top: -2px;
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
}
.friends-alarm-wrapper {
  -webkit-box-flex: 0;
  flex: 0 0 auto;
  margin-left: 8px;
}
</style>
