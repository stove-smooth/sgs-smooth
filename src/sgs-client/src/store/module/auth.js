import { loginUser } from "../../api/index.js";
import {
  getAccessAuthToCookie,
  getRefreshAuthToCookie,
  getUserEmailToCookie,
  getUserNickNameToCookie,
  getUserCodeToCookie,
  saveAccessAuthToCookie,
  saveRefreshAuthToCookie,
  saveUserEmailToCookie,
  saveUserNickNameToCookie,
  saveUserCodeToCookie,
  deleteCookie,
} from "../../utils/cookies";

const auth = {
  namespaced: true,
  state: {
    email: getUserEmailToCookie() || "",
    nickname: getUserNickNameToCookie() || "",
    code: getUserCodeToCookie() || "",
    accesstoken: getAccessAuthToCookie() || "",
    refreshtoken: getRefreshAuthToCookie() || "",
  },
  getters: {
    isLogin: (state) => {
      return state.email !== "";
    },
    getAccessToken: (state) => {
      return state.accesstoken;
    },
    getRefreshToken: (state) => {
      return state.refreshtoken;
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
      console.log("setcode");
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
      console.log(userData);
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
    LOGOUT({ commit }) {
      console.log("로그아웃");
      commit("clearEmail");
      commit("clearNickname");
      commit("clearCode");
      commit("clearAccessToken");
      commit("clearRefreshToken");
      deleteCookie("accessauth");
      deleteCookie("refreshauth");
      deleteCookie("useremail");
      deleteCookie("usernickname");
      deleteCookie("usercode");
    },
  },
};
export default auth;
