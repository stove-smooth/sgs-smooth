<template>
  <div>
    <a href="javascript:;" @click="logoutUser">Logout</a>
    <div>
      <svg class="close" @click="closeSettings"></svg>
    </div>
  </div>
</template>

<script>
import { deleteCookie } from "../utils/cookies.js";
export default {
  methods: {
    closeSettings() {
      this.$router.go(-1);
    },
    logoutUser() {
      this.$store.commit("clearEmail");
      this.$store.commit("clearNickname");
      this.$store.commit("clearCode");
      this.$store.commit("clearAccessToken");
      this.$store.commit("clearRefreshToken");
      deleteCookie("accessauth");
      deleteCookie("refreshauth");
      deleteCookie("useremail");
      deleteCookie("usernickname");
      deleteCookie("usercode");
      this.$router.push("/");
    },
  },
};
</script>

<style>
.close {
  display: flex;
  background-image: url("../assets/close.svg");
  width: 50px;
  height: 50px;
}
</style>
