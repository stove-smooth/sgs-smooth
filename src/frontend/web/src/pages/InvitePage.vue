<template>
  <div></div>
</template>

<script>
import { joinCommunity } from "../api";
export default {
  created() {
    if (this.$route.params.invitePath == "c") {
      this.joinCommunity(
        this.$route.params.communityId,
        this.$route.params.invitePath
      );
    }
  },
  methods: {
    async joinCommunity(communityId) {
      const communityHashCode = {
        code: communityId,
      };
      try {
        const result = await joinCommunity(communityHashCode);
        this.$router.replace("/channels/" + result.data.result.id);
      } catch (err) {
        //로그인 안되어있을경우. app파일에서 한 번 더 기회를 준다.
      }
    },
  },
};
</script>

<style></style>
