<template>
  <div>
    <login-form></login-form>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import LoginForm from "../components/LoginForm.vue";
export default {
  components: { LoginForm },
  computed: {
    ...mapGetters("auth", ["isLogin"]),
  },
  created() {
    if (this.isLogin) {
      this.$router.push("/channels/@me");
    }
  },
};
</script>

<style></style>
