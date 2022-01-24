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
    ...mapGetters("user", ["getEmail"]),
  },
  created() {
    if (this.getEmail) {
      this.$router.push("/channels/@me");
    }
  },
  mounted() {
    if (this.$route.params?.message) {
      if (this.$route.params?.message === "sessionOut") {
        this.$message.error(
          "로그인 세션이 만료되었습니다. 재로그인이 필요합니다."
        );
      }
    }
  },
};
</script>

<style></style>
