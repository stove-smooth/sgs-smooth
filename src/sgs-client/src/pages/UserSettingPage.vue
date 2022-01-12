<template>
  <div>
    <a href="javascript:;" @click="logoutUser">Logout</a>
    <div>
      <svg class="close" @click="closeSettings"></svg>
    </div>
  </div>
</template>

<script>
export default {
  methods: {
    closeSettings() {
      this.$router.go(-1);
    },
    async logoutUser() {
      await this.$store.dispatch("LOGOUT");
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
