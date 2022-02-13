import firebase from "firebase/compat/app";
import "firebase/compat/messaging";
import axios from "axios";
import Vue from "vue";
import App from "./App.vue";
import { router } from "./routes";
import { loadGuard } from "./routes/guard.js";
import store from "./store/index.js";
import { firebaseConfig } from "./utils/firebaseConfig";

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

// 토큰값 확인
messaging.getToken().then((token) => {
  alert(token);
});

loadGuard(router, store);

Vue.config.productionTip = false;
Vue.prototype.$http = axios;

new Vue({
  render: (h) => h(App),
  router,
  store,
}).$mount("#app");
