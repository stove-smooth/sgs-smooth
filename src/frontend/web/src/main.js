import axios from "axios";
import Vue from "vue";
import "@/utils/firebase";
import App from "./App.vue";
import { router } from "./routes";
import { loadGuard } from "./routes/guard.js";
import store from "./store/index.js";
//import message from "./utils/message";

loadGuard(router, store);

//Vue.use(message);
Vue.config.productionTip = false;
Vue.prototype.$http = axios;

//window.sendMessage = message;

new Vue({
  render: (h) => h(App),
  router,
  store,
}).$mount("#app");
