import axios from "axios";
import store from "../store/index";
import { setInterceptors } from "./common/interceptors";
function createInstance() {
  const instance = axios.create({
    baseURL: process.env.VUE_APP_BASE_URL,
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
function deleteProfileImage() {
  return instance.patch("auth-server/auth/d/profile");
}
async function createNewCommunity(userData) {
  try {
    const accesstoken = await store.getters["user/getAccessToken"];
    const response = await axios.post(
      "http://52.79.229.100:8000/community-server/community",
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
    console.log(err.response);
  }
}
function fetchCommunityList() {
  return instance.get("community-server/community");
}
/* function getFriendsProfile(userId) {
  console.log("룰루?", userId);
  return instance.post("auth-server/auth/find-id-list", [userId]);
} */
function fetchCommunityInfo(communityId) {
  return instance.get("community-server/community/" + communityId);
}
function fetchCommunityMemberList(communityId) {
  return instance.get(`community-server/community/${communityId}/member`);
}
function createNewCategory(categoryData) {
  return instance.post("community-server/category", categoryData);
}
function deleteCategory(categoryId) {
  return instance.delete("community-server/category/" + categoryId);
}
function createNewChannel(channelData) {
  return instance.post("community-server/channel", channelData);
}
function moveCategory(categoryData) {
  return instance.patch("community-server/category/location", categoryData);
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
  deleteProfileImage,
  createNewCommunity,
  fetchCommunityList,
  fetchCommunityInfo,
  fetchCommunityMemberList,
  //getFriendsProfile,
  createNewCategory,
  deleteCategory,
  createNewChannel,
  moveCategory,
};
