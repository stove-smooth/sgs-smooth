import Vue from "vue";
import Vuex from "vuex";
import modules from "./module";
Vue.use(Vuex);

const store = new Vuex.Store({ modules });
export default store;
