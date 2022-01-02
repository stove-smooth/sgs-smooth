import Vue from "vue";
import App from "./App.vue";
import { router } from "./routes/index.js";
import store from "./store/index.js";
import axios from "axios";
Vue.config.productionTip = false;
Vue.prototype.$http = axios;
new Vue({
  router,
  store,
  render: (h) => h(App),
}).$mount("#app");
