<template>
  <section class="primary-header">
    <div class="header-children-wrapper">
      <div class="primary-icon-wrapper">
        <svg class="hashtag-icon"></svg>
      </div>
      <h3 class="server-name" aria-label="channel-name">{{ $route.params }}</h3>
    </div>
    <div class="primary-header-toolbar">
      <div
        aria-label="스레드"
        role="button"
        tabindex="0"
        class="primary-icon-wrapper"
      >
        <svg class="thread-icon"></svg>
      </div>
      <div
        aria-label="알림설정"
        role="button"
        tabindex="0"
        class="primary-icon-wrapper align-items-center"
      >
        <svg class="big-alarms-icon"></svg>
      </div>
      <div
        aria-label="고정된 메시지"
        role="button"
        tabindex="0"
        class="primary-icon-wrapper align-items-center"
      >
        <svg class="fixed-icon"></svg>
      </div>
      <div class="server-chatting-searchbar"><search-bar></search-bar></div>
      <div
        aria-label="메일 보관함"
        role="button"
        tabindex="0"
        class="primary-icon-wrapper align-items-center"
      >
        <svg class="mail-box"></svg>
      </div>
    </div>
  </section>
</template>

<script>
import SearchBar from "./common/SearchBar.vue";
export default {
  components: {
    SearchBar,
  },
};
</script>

<style>
.thread-icon {
  display: flex;
  width: 24px;
  height: 24px;
  background-image: url("../assets/thread-icon.svg");
}
.big-alarms-icon {
  display: flex;
  width: 20px;
  height: 20px;
  background-image: url("../assets/big-alarms.svg");
}
.fixed-icon {
  width: 20px;
  height: 20px;
  background-image: url("../assets/fixed.svg");
}
.server-chatting-searchbar {
  width: 240px;
}
</style>
