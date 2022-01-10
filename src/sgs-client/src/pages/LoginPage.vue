<template>
  <div>
    <login-form></login-form>
  </div>
</template>

<script>
import LoginForm from "../components/LoginForm.vue";
export default {
  components: { LoginForm },
  created() {
    if (this.$store.getters.isLogin) {
      this.$router.push("/channels/@me");
    }
  },
};
</script>

<style></style>
