<template>
  <div>
    <div class="wrapper2">
      <div class="wrapper">
        <div class="container">
          <navigation-bar
            @create-server="openCreateServer"
            v-if="$store.getters.isLogin && navbar"
          ></navigation-bar>
          <router-view></router-view>
        </div>
      </div>
    </div>
    <create-server-modal
      v-if="createServer"
      @exit="exiteCreateServer"
    ></create-server-modal>
  </div>
</template>

<script>
import NavigationBar from "./components/NavigationBar.vue";
import CreateServerModal from "./components/CreateServerModal.vue";
export default {
  name: "App",
  components: { NavigationBar, CreateServerModal },
  data() {
    return {
      navbar: true,
      createServer: false,
    };
  },
  watch: {
    // 라우터의 변경을 감시
    $route(to, from) {
      if (to.path != from.path) {
        if (to.path === "/settings") {
          this.navbar = false;
        } else {
          this.navbar = true;
        }
      }
    },
  },
  methods: {
    openCreateServer() {
      this.createServer = true;
    },
    exiteCreateServer() {
      this.createServer = false;
    },
  },
};
</script>

<style>
@import "./css/common.css";
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
