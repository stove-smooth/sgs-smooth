<template>
  <div>
    <login-form :path="this.path" :communityId="this.communityId"></login-form>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import LoginForm from "../components/LoginForm.vue";
export default {
  components: { LoginForm },
  data() {
    return {
      path: this.$route.query.path,
      communityId: this.$route.query.communityId,
    };
  },
  computed: {
    ...mapGetters("user", ["getEmail"]),
  },
  created() {
    if (this.getEmail) {
      this.$router.push("/channels/@me");
    }
    console.log(this.$route.query);
    console.log(this.path);
  },
  mounted() {
    if (this.$route.params?.message) {
      if (this.$route.params?.message === "sessionOut") {
        this.$message.error(
          "로그인 세션이 만료되었습니다. 재로그인이 필요합니다."
        );
      }
    }
    console.log(this.$route.query);
    console.log(this.path);
  },
};
</script>

<style></style>
