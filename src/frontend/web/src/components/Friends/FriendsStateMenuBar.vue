<template>
  <section class="primary-header">
    <div class="header-children-wrapper">
      <div class="primary-icon-wrapper align-items-center">
        <svg class="friends-icon"></svg>
      </div>
      <h3 class="friends-section-title">친구</h3>
      <div class="divider"></div>
      <div
        class="friends-tabbar"
        role="tablelist"
        aria-orientation="horiaontal"
        aria-lable="친구"
      >
        <div
          class="friends-tab-decorator"
          role="tab"
          aria-controls="online-tab"
          tabindex="0"
          @click="setFriendsStateMenu('online')"
          v-bind:class="{
            'friends-tab-decorator-clicked': friendsStateMenu === 'online',
          }"
        >
          온라인
        </div>
        <div
          class="friends-tab-decorator"
          role="tab"
          aria-controls="all-tab"
          tabindex="-1"
          @click="setFriendsStateMenu('all')"
          v-bind:class="{
            'friends-tab-decorator-clicked': friendsStateMenu === 'all',
          }"
        >
          모두
        </div>
        <div
          class="friends-tab-decorator"
          role="tab"
          aria-controls="pending-tab"
          tabindex="-1"
          @click="setFriendsStateMenu('waiting')"
          v-bind:class="{
            'friends-tab-decorator-clicked': friendsStateMenu === 'waiting',
          }"
        >
          대기 중
          <number-badge
            v-show="friendsWaitNumber"
            :alarms="friendsWaitNumber"
          ></number-badge>
        </div>
        <div
          class="friends-tab-decorator"
          role="tab"
          aria-controls="blocked-tab"
          tabindex="-1"
          @click="setFriendsStateMenu('blockedlist')"
          v-bind:class="{
            'friends-tab-decorator-clicked': friendsStateMenu === 'blockedlist',
          }"
        >
          차단 목록
        </div>
        <div
          class="friends-tab-decorator add-friends-button"
          @click="setFriendsStateMenu('addfriends')"
        >
          <span>친구 추가하기</span>
        </div>
      </div>
    </div>
    <div class="primary-header-toolbar">
      <!-- <div class="invite-toolbar">
        <div
          class="primary-icon-wrapper clickable"
          role="button"
          aria-label="새로운 그룹 메시지"
        >
          <svg class="invite-icon"></svg>
        </div>
        <div class="divider"></div>
      </div>
      <div
        class="primary-icon-wrapper clickable align-items-center"
        role="button"
        aria-label="받은 편지함"
      >
        <svg class="mail-box"></svg>
      </div> -->
    </div>
  </section>
</template>

<script>
import { mapState, mapMutations } from "vuex";
import NumberBadge from "../common/NumberBadge.vue";
export default {
  components: {
    NumberBadge,
  },
  computed: {
    ...mapState("friends", ["friendsWaitNumber", "friendsStateMenu"]),
  },
  methods: {
    ...mapMutations("friends", ["setFriendsStateMenu"]),
  },
};
</script>

<style>
.friends-section-title {
  -webkit-box-pack: start;
  justify-content: flex-start;
  margin: 0 8px 0 0;
  flex: 0 0 auto;
  min-width: auto;
  overflow: hidden;
  white-space: nowrap;
  -webkit-box-flex: 0;
  display: flex;
  -webkit-box-align: center;
  align-items: center;
  box-sizing: border-box;
  color: var(--white-color);
}
.divider {
  width: 1px;
  height: 24px;
  margin: 0 8px;
  -webkit-box-flex: 0;
  flex: 0 0 auto;
  background: hsla(0, 0%, 100%, 0.06);
}
.friends-tabbar {
  display: flex;
  -webkit-box-orient: horizontal;
  -webkit-box-direction: normal;
  flex-direction: row;
}
.friends-tab-decorator {
  display: flex;
  -webkit-box-pack: center;
  justify-content: center;
  -webkit-box-align: center;
  align-items: center;
  text-align: center;
  min-width: 40px;
  -webkit-app-region: no-drag;
  border-radius: 4px;
  margin: 0 8px;
  padding: 2px 8px;
  color: var(--description-primary);
  position: relative;
  font-size: 16px;
  line-height: 20px;
  cursor: pointer;
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
  flex-shrink: 0;
  font-weight: 500;
}
.friends-tab-decorator-clicked {
  background-color: rgb(47 49 54);
  cursor: default;
  color: var(--white-color);
}
.add-friends-button {
  color: hsl(0, calc(var(--saturation-factor, 1) * 0%), 100%);
  background-color: hsl(139, calc(var(--saturation-factor, 1) * 47.3%), 43.9%);
}

.invite-toolbar {
  display: flex;
}
@media (max-width: 940px) {
  .invite-toolbar {
    display: none;
  }
}
.invite-icon {
  display: flex;
  width: 24px;
  height: 24px;
  background-image: url("../../assets/invite-group-message.svg");
}
.mail-box {
  display: flex;
  width: 20px;
  height: 20px;
  background-image: url("../../assets/mail-box.svg");
}
</style>
