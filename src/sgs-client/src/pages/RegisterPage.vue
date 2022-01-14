<template>
  <div>
    <register-form></register-form>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import RegisterForm from "../components/RegisterForm.vue";
export default {
  components: { RegisterForm },
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
