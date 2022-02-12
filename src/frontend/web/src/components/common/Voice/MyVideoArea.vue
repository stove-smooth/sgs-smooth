<template>
  <div>
    <voice-participants :participant="voiceMember"></voice-participants>
  </div>
</template>

<script>
import { mapState, mapGetters } from "vuex";
import VoiceParticipants from "./VoiceParticipants.vue";
export default {
  components: { VoiceParticipants },
  computed: {
    ...mapState("voice", ["participants"]),
    ...mapGetters("user", ["getUserId"]),
    voiceMember() {
      //참여자 감지
      if (this.participants) {
        return this.participants[this.getUserId];
      } else {
        return null;
      }
    },
  },
};
</script>

<style></style>
