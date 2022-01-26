<template>
  <div>오잉?</div>
</template>

<script>
export default {
  created() {
    console.log(window.location.pathname);
    console.log(this.$route.params);
    /* if(this.$route.params.invitePath=="c"){

    } */
  },
};
</script>

<style></style>
