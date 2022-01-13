import {
  saveAccessAuthToCookie,
  saveRefreshAuthToCookie,
  saveUserEmailToCookie,
  saveUserNickNameToCookie,
  saveUserCodeToCookie,
  deleteCookie,
} from "../utils/cookies";
import { loginUser, fetchWaitingFriends } from "../api/index.js";
export default {
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
  async FETCH_FRIENDSWAITING({ commit }) {
    const result = await fetchWaitingFriends();
    console.log(result.data.result);
    commit("setReceivedWaitingFriends", result.data.result.receiveFromFriend);
    commit("setSendWaitingFriends", result.data.result.sendToFriend);
  },
};
