import Vue from "vue";
import Vuex from "vuex";
import mutations from "./mutations.js";
import actions from "./actions.js";
import {
  getAccessAuthToCookie,
  getRefreshAuthToCookie,
  getUserEmailToCookie,
  getUserNickNameToCookie,
  getUserCodeToCookie,
} from "../utils/cookies";
Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    email: getUserEmailToCookie() || "",
    nickname: getUserNickNameToCookie() || "",
    code: getUserCodeToCookie() || "",
    accesstoken: getAccessAuthToCookie() || "",
    refreshtoken: getRefreshAuthToCookie() || "",
    createchannel: false,
    friendsstatemenu: "online",
    friendsonline: [],
    friendsall: [],
    friendswaiting: [],
    friendswaitingnumber: 0,
    friendsblocked: [],
  },
  getters: {
    isLogin(state) {
      return state.email !== "";
    },
  },
  mutations,
  actions,
});
