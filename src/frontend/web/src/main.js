import axios from "axios";
import Vue from "vue";
import Swal from "sweetalert2";
import "@/utils/firebase";
import App from "./App.vue";
import { router } from "./routes";
import { loadGuard } from "./routes/guard.js";
import store from "./store/index.js";

loadGuard(router, store);

Vue.config.productionTip = false;
Vue.prototype.$http = axios;
Vue.prototype.$swal = Swal;

new Vue({
  render: (h) => h(App),
  router,
  store,
}).$mount("#app");
