import { loginUser, fetchUserInfo } from "../../api/index.js";
const auth = {
  namespaced: true,
  state: {
    email: "",
    nickname: "",
    code: "",
    accesstoken: "",
    refreshtoken: "",
    userimage: "",
    useraboutme: "",
  },
  getters: {
    getEmail: (state) => {
      if (!state.email) {
        try {
          const token = localStorage.getItem("email");
          if (token) {
            state.email = JSON.parse(token);
          }
        } catch (e) {
          console.error(e);
        }
      }
      return state.email;
    },
    getAccessToken: (state) => {
      if (!state.accesstoken) {
        try {
          const token = localStorage.getItem("accesstoken");
          if (token) {
            state.accesstoken = JSON.parse(token);
          }
        } catch (e) {
          console.error(e);
        }
      }
      return state.accesstoken;
    },
    getRefreshToken: (state) => {
      if (!state.refreshtoken) {
        try {
          const token = localStorage.getItem("refreshtoken");
          if (token) {
            state.refreshtoken = JSON.parse(token);
          }
        } catch (e) {
          console.error(e);
        }
      }
      return state.refreshtoken;
    },
  },
  mutations: {
    setEmail(state, email) {
      state.email = email;
      localStorage.setItem("email", JSON.stringify(email));
    },
    setNickname(state, nickname) {
      state.nickname = nickname;
    },
    setCode(state, code) {
      state.code = code;
    },
    setAccessToken(state, accessToken) {
      state.accesstoken = accessToken;
      localStorage.setItem("accesstoken", JSON.stringify(accessToken));
    },
    setRefreshToken(state, refreshToken) {
      state.refreshtoken = refreshToken;
      localStorage.setItem("refreshtoken", JSON.stringify(refreshToken));
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
      commit("setAccessToken", response.data.result.accessToken);
      commit("setRefreshToken", response.data.result.refreshToken);
    },
    LOGOUT({ commit }) {
      localStorage.removeItem("email");
      localStorage.removeItem("accesstoken");
      localStorage.removeItem("refreshtoken");
      commit("clearEmail");
      commit("clearAccessToken");
      commit("clearRefreshToken");
    },
    async FETCH_USERINFO({ commit }) {
      const response = await fetchUserInfo();
      commit("setNickname", response.data.result.name);
      commit("setCode", response.data.result.code);
      commit("setUserAboutMe", response.data.result.bio);
      commit("setUserImage", response.data.result.profileImage);
    },
  },
};
export default auth;
