import axiosInstance from "./common/axiosInstance";

const instance = axiosInstance();

function readDMChatMessage(channelId, pageId) {
  return instance.get(`chat-server/direct?ch_id=${channelId}&page=${pageId}`);
}
function fetchDirectMessageList() {
  return instance.get(`community-server/room`);
}
function createDirectMessage(membersInfo) {
  return instance.post(`community-server/room`, membersInfo);
}
function fetchDirectMessageMemberList(roomId) {
  return instance.get(`community-server/room/${roomId}`);
}
function exitDirectMessage(roomId, memberId) {
  return instance.delete(
    `community-server/room/${roomId}/member?id=${memberId}`
  );
}

export {
  readDMChatMessage,
  fetchDirectMessageList,
  createDirectMessage,
  fetchDirectMessageMemberList,
  exitDirectMessage,
};
