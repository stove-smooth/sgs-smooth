import Vue from "vue";
import App from "./App.vue";
import { router } from "./routes";
import { loadGuard } from "./routes/guard.js";
import store from "./store/index.js";
import axios from "axios";
Vue.config.productionTip = false;
loadGuard(router, store);
Vue.prototype.$http = axios;
new Vue({
  render: (h) => h(App),
  router,
  store,
}).$mount("#app");
