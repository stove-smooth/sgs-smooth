<template>
  <div>오잉?</div>
</template>

<script>
import { joinCommunity } from "../api";
export default {
  created() {
    console.log(window.location.pathname);
    console.log(this.$route.params);
    if (this.$route.params.invitePath == "c") {
      this.joinCommunity(
        this.$route.params.communityId,
        this.$route.params.invitePath
      );
    }
  },
  methods: {
    async joinCommunity(communityId) {
      console.log("join", communityId);
      const communityHashCode = {
        code: communityId,
      };
      try {
        const result = await joinCommunity(communityHashCode);
        this.$router.replace("/channels/" + result.data.result.id);
      } catch (err) {
        console.log("error", err.response);
        //로그인 안되어있을경우. app파일에서 한 번 더 기회를 준다.
        if (err.response.status == 401) {
          console.log("로그인안됨");
        }
      }
    },
  },
};
</script>

<style></style>
