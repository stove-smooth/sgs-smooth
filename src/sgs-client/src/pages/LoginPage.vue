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
    console.log("로그인페이지1");
    if (this.$route.params?.message) {
      console.log("로그인페이지2");
      if (this.$route.params?.message === "sessionOut") {
        console.log("로그인페이지3");
        this.$message.error(
          "로그인 세션이 만료되었습니다. 재로그인이 필요합니다."
        );
      }
    }
  },
};
</script>

<style></style>
