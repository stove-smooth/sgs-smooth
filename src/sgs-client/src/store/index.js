import Vue from "vue";
import Vuex from "vuex";
/* import auth from "./module/auth.js";
import friends from "./module/friends.js";
import server from "./module/server.js"; */
import modules from "./module";
Vue.use(Vuex);

const store = new Vuex.Store({ modules });
export default store;
