import axios from "axios";
import store from "../store/index";
import { setInterceptors } from "./common/interceptors";

function createInstance() {
  const instance = axios.create({
    baseURL: "http://52.79.229.100:8000/",
  });
  return setInterceptors(instance);
}
const instance = createInstance();

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
    const accesstoken = await store.getters["auth/getAccessToken"];
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
function deleteProfileImage() {
  return instance.patch("auth-server/auth/d/profile");
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
  deleteProfileImage,
};
