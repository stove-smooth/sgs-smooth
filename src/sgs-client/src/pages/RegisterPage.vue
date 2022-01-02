<template>
  <div>
    <register-form></register-form>
  </div>
</template>

<script>
import RegisterForm from "../components/RegisterForm.vue";
export default {
  components: { RegisterForm },
  created() {
    if (this.$store.getters.isLogin) {
      this.$router.push("/channels/@me");
    }
  },
};
</script>

<style></style>
