export default {
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
  setAllFriends(state) {
    state.friendsall = "";
  },
  setOnlineFriends(state) {
    state.friendsonline = "";
  },
  setReceivedWaitingFriends(state, friendsreceivedwaiting) {
    state.friendsreceivedwaiting = friendsreceivedwaiting;
    state.friendsreceivedwaitingnumber = friendsreceivedwaiting.length;
  },
  setSendWaitingFriends(state, friendssendwaiting) {
    state.friendssendwaiting = friendssendwaiting;
  },
  setBlockedFriends(state) {
    state.friendsblocked = "";
  },
};
