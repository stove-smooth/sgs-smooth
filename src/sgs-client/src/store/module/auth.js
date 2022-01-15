import { loginUser, fetchUserInfo } from "../../api/index.js";
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
    userimage: "",
    useraboutme: "",
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
      state.code = code;
    },
    setAccessToken(state, accessToken) {
      state.accesstoken = accessToken;
    },
    setRefreshToken(state, refreshToken) {
      state.refreshtoken = refreshToken;
    },
    setUserImage(state, userImage) {
      state.userimage = userImage;
    },
    setUserAboutMe(state, userAboutMe) {
      state.useraboutme = userAboutMe;
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
    LOGOUT({ commit }) {
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
    async FETCH_USERINFO({ commit }) {
      const response = await fetchUserInfo();
      commit("setUserAboutMe", response.data.result.bio);
      commit("setUserImage", response.data.result.profileImage);
    },
  },
};
export default auth;
