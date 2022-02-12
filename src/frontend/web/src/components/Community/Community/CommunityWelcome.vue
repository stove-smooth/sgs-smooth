<template>
  <div
    class="server-chatting-container justify-content-center align-items-center"
  >
    <div class="header-title">
      {{ communityInfo.name }}서버에 오신 것을 환영합니다.
      <div>아직 채팅 채널이 없네요! 채팅 채널을 만들어 주세요.</div>
    </div>
  </div>
</template>

<script>
import { mapState } from "vuex";
export default {
  computed: {
    ...mapState("server", ["communityInfo"]),
  },
};
</script>

<style></style>
