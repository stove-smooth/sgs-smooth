<template>
  <div class="wrapper2">
    <div class="wrapper">
      <div v-if="wsOpen"><video-mobile-form></video-mobile-form></div>
    </div>
  </div>
</template>

<script>
import { mapActions, mapState } from "vuex";
import VideoMobileForm from "../components/VideoMobileForm.vue";
export default {
  components: { VideoMobileForm },
  async created() {
    const wsInfo = {
      url: process.env.VUE_APP_WEBRTC_URL,
      type: "mobile",
    };
    await this.wsInit(wsInfo); //ws 전역 등록.
  },
  computed: {
    ...mapState("voice", ["wsOpen"]),
  },
  methods: {
    ...mapActions("voice", ["wsInit"]),
  },
};
</script>
<style></style>
