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
