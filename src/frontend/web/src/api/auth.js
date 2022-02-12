import axios from "axios";
import axiosInstance from "./common/axiosInstance";
import store from "../store/index";

const instance = axiosInstance();

function registerUser(userData) {
  return instance.post("auth-server/sign-up", userData);
}
function loginUser(userData) {
  return instance.post("auth-server/sign-in", userData);
}
function sendAuthCode(userData) {
  return instance.post("auth-server/send-mail?email=" + userData.email);
}
function verifyAuthCode(authcode) {
  return instance.get("auth-server/check-email?key=" + authcode);
}
function friendRequest(userData) {
  return instance.post("auth-server/auth/friend", userData);
}
function fetchFriends() {
  return instance.get("auth-server/auth/friend");
}
function fetchUserInfo() {
  return instance.get("auth-server/auth/info");
}
async function changeUserImage(userData) {
  try {
    const accesstoken = await store.getters["user/getAccessToken"];
    const response = await axios.post(
      "http://52.79.229.100:8000/auth-server/auth/profile",
      userData,
      {
        headers: {
          AUTHORIZATION: accesstoken,
          "Content-Type": "multipart/form-data",
        },
      }
    );
    return response;
  } catch (err) {
    console.log(err);
  }
}
function acceptFriend(userId) {
  return instance.patch("auth-server/auth/friend?id=" + userId);
}
function deleteFriend(userId) {
  return instance.delete("auth-server/auth/friend?id=" + userId);
}
function blockFriend(userId) {
  return instance.patch("auth-server/auth/ban-friend?id=" + userId);
}
function fetchMemberInfo(id) {
  return instance.get(`auth-server/name?id=${id}`);
}
export {
  registerUser,
  loginUser,
  sendAuthCode,
  verifyAuthCode,
  friendRequest,
  fetchFriends,
  fetchUserInfo,
  changeUserImage,
  acceptFriend,
  deleteFriend,
  blockFriend,
  fetchMemberInfo,
};
