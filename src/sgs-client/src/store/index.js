import Vue from "vue";
import Vuex from "vuex";
import {
  saveAccessAuthToCookie,
  saveRefreshAuthToCookie,
  saveUserEmailToCookie,
  saveUserNickNameToCookie,
  saveUserCodeToCookie,
  getAccessAuthToCookie,
  getRefreshAuthToCookie,
  getUserEmailToCookie,
  getUserNickNameToCookie,
  getUserCodeToCookie,
} from "../utils/cookies";
import { loginUser } from "../api/index.js";
Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    email: getUserEmailToCookie() || "",
    nickname: getUserNickNameToCookie() || "",
    code: getUserCodeToCookie() || "",
    accesstoken: getAccessAuthToCookie() || "",
    refreshtoken: getRefreshAuthToCookie() || "",
  },
  getters: {
    isLogin(state) {
      return state.email !== "";
    },
  },
  mutations: {
    setEmail(state, email) {
      state.email = email;
    },
    setNickname(state, nickname) {
      state.nickname = nickname;
    },
    setCode(state, code) {
      state.code = code;
    },
    setAccessToken(state, accessToken) {
      state.accesstoken = accessToken;
    },
    setRefreshToken(state, refreshToken) {
      state.refreshtoken = refreshToken;
    },
    clearEmail(state) {
      state.email = "";
    },
    clearNickname(state) {
      state.nickname = "";
    },
    clearCode(state) {
      state.code = "";
    },
    clearAccessToken(state) {
      state.accesstoken = "";
    },
    clearRefreshToken(state) {
      state.refreshtoken = "";
    },
  },
  actions: {
    async LOGIN({ commit }, userData) {
      const response = await loginUser(userData);
      commit("setEmail", response.data.result.email);
      commit("setNickname", response.data.result.name);
      commit("setCode", response.data.result.code);
      commit("setAccessToken", response.data.result.accessToken);
      commit("setRefreshToken", response.data.result.refreshToken);
      saveAccessAuthToCookie(response.data.result.accessToken);
      saveRefreshAuthToCookie(response.data.result.refreshToken);
      saveUserCodeToCookie(response.data.result.code);
      saveUserEmailToCookie(response.data.result.email);
      saveUserNickNameToCookie(response.data.result.name);
    },
  },
});
