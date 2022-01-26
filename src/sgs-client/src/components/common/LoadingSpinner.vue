<template>
  <div class="modal">
    <div class="blurred-background background-color-black">
      <div class="spinner-container">
        <svg class="logo-spinner"></svg>
      </div>
    </div>
  </div>
</template>

<script>
export default {};
</script>

<style scoped>
.background-color-black {
  background: black;
  display: flex;
  justify-content: center;
  align-items: center;
}
.spinner-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 240px;
}
.logo-spinner {
  width: 117px;
  height: 117px;
  background-image: url("../../assets/big-purple-discord-logo.svg");
  animation: spin 0.5s linear infinite;
}
@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}
</style>
