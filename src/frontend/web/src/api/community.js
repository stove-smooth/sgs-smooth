import axios from "axios";
import axiosInstance from "./common/axiosInstance";
import store from "../store/index";

const instance = axiosInstance();

/* 커뮤니티 */
//커뮤니티 crud
async function createNewCommunity(userData) {
  try {
    const accesstoken = await store.getters["user/getAccessToken"];
    const response = await axios.post(
      process.env.VUE_APP_BASE_URL + "community-server/community",
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
function updateCommunityName(communityInfo) {
  return instance.patch("community-server/community/name", communityInfo);
}
function deleteCommunity(communityId) {
  return instance.delete(`community-server/community/${communityId}`);
}
function fetchCommunityList() {
  return instance.get("community-server/community");
}
function fetchCommunityInfo(communityId) {
  return instance.get("community-server/community/" + communityId);
}
function fetchCommunityMemberList(communityId) {
  return instance.get(`community-server/community/${communityId}/member`);
}
function exitCommunity(communityId, userId) {
  return instance.delete(
    `community-server/community/${communityId}/member?id=` + userId
  );
}
//커뮤니티 초대
function createInvitation(invitationData) {
  return instance.post("community-server/community/invitation", invitationData);
}
function joinCommunity(communityHashCode) {
  return instance.post(`community-server/community/member`, communityHashCode);
}
/* 카테고리 */
function createNewCategory(categoryData) {
  return instance.post("community-server/category", categoryData);
}
function updateCategoryName(categoryInfo) {
  return instance.patch("community-server/category/name", categoryInfo);
}
function deleteCategory(categoryId) {
  return instance.delete("community-server/category/" + categoryId);
}
/* 채널 */
function createNewChannel(channelData) {
  return instance.post("community-server/channel", channelData);
}
function updateChannelName(channelInfo) {
  return instance.patch("community-server/channel/name", channelInfo);
}
function deleteChannel(channelId) {
  return instance.delete(`community-server/channel/${channelId}`);
}
/* 채팅 */
function readChatMessage(channelId, pageId) {
  return instance.get(
    `chat-server/community?ch_id=${channelId}&page=${pageId}`
  );
}
async function sendImageChatting(userData) {
  try {
    const accesstoken = await store.getters["user/getAccessToken"];
    const response = await axios.post(
      process.env.VUE_APP_BASE_URL + "chat-server/channel/file",
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
async function sendImageDirectChatting(userData) {
  try {
    const accesstoken = await store.getters["user/getAccessToken"];
    const response = await axios.post(
      process.env.VUE_APP_BASE_URL + "chat-server/file",
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
/* drag and drop */
function moveCategory(categoryData) {
  return instance.patch("community-server/category/location", categoryData);
}
function moveChannel(channelData) {
  return instance.patch("community-server/channel/location", channelData);
}
function moveCommunity(communityData) {
  return instance.patch("community-server/community/location", communityData);
}
export {
  createNewCommunity,
  fetchCommunityList,
  fetchCommunityInfo,
  fetchCommunityMemberList,
  createNewCategory,
  deleteCategory,
  createNewChannel,
  moveCategory,
  moveChannel,
  sendImageChatting,
  deleteCommunity,
  createInvitation,
  deleteChannel,
  exitCommunity,
  joinCommunity,
  readChatMessage,
  moveCommunity,
  sendImageDirectChatting,
  updateCommunityName,
  updateChannelName,
  updateCategoryName,
};
