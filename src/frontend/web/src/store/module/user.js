import { fetchUserInfo } from "../../api/index.js";
import { loginUser } from "@/api/index.js";
const user = {
  namespaced: true,
  state: {
    userId: "",
    email: "",
    nickname: "",
    code: "",
    accesstoken: "",
    refreshtoken: "",
    userimage: "",
    useraboutme: "",
  },
  getters: {
    getUserId: (state) => {
      if (!state.userId) {
        try {
          const token = localStorage.getItem("userId");
          if (token) {
            state.userId = JSON.parse(token);
          }
        } catch (e) {
          console.error(e);
        }
      }
      return state.userId;
    },
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
    setUserId(state, userId) {
      state.userId = userId;
      localStorage.setItem("userId", JSON.stringify(userId));
    },
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
    clearUserId(state) {
      state.userId = "";
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
      commit("setUserId", response.data.result.id);
      commit("setEmail", response.data.result.email);
      commit("setAccessToken", response.data.result.accessToken);
      commit("setRefreshToken", response.data.result.refreshToken);
      return response.data.result.code;
    },
    LOGOUT({ commit }) {
      localStorage.removeItem("userId");
      localStorage.removeItem("email");
      localStorage.removeItem("accesstoken");
      localStorage.removeItem("refreshtoken");
      commit("clearUserId");
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
export default user;
