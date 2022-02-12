<template>
  <div>
    <router-view></router-view>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
export default {
  mounted() {
    if (!this.getEmail) {
      //로그인이 안되어 있을경우
      if (!this.$route.params.invitePath) {
        this.$router.replace("/login");
      } else {
        //초대장 코드로 들어왔다면, 로그인 페이지에 초대장 정보를 함께 전송
        this.$router.push({
          name: "LoginPage",
          query: {
            path: this.$route.params.invitePath,
            communityId: this.$route.params.communityId,
          },
        });
      }
    } else {
      if (this.$route.path == "/") {
        this.$router.replace("/channels/@me");
      }
    }
  },
  computed: {
    ...mapGetters("user", ["getEmail"]),
  },
};
</script>
<style>
@import "./css/common.css";
.wrapper2 {
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  background-color: var(--dark-grey-color);
  display: flex;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  flex-direction: column;
}
.container {
  position: relative;
  overflow: hidden;
  width: 100%;
  height: 100%;
  display: flex;
}
button {
  font-weight: 500;
  border: 0;
  cursor: pointer;
}
a img {
  border: none;
}
</style>
