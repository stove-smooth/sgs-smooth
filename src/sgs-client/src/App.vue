<template>
  <div class="wrapper2">
    <div class="wrapper">
      <div class="container">
        <navigation-bar v-if="$store.getters.isLogin"></navigation-bar>
        <router-view></router-view>
      </div>
    </div>
  </div>
</template>

<script>
import NavigationBar from "./components/NavigationBar.vue";
export default {
  name: "App",
  components: { NavigationBar },
};
</script>

<style>
.wrapper2 {
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  background-color: #202225;
  /*   display: -webkit-box;
  display: -ms-flexbox; */
  display: flex;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  /*   -ms-flex-direction: column; */
  flex-direction: column;
}
.container {
  position: relative;
  overflow: hidden;
  width: 100%;
  height: 100%;
  display: flex;
}
button {
  font-weight: 500;
  border: 0;
  cursor: pointer;
}
a img {
  border: none;
}
</style>
