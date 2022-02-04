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
        <svg class="fixed-icon clickable"></svg>
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

<style></style>
