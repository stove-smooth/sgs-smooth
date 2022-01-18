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
};
</script>

<style></style>
