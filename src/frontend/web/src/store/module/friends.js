import { fetchFriends, fetchFriendsState } from "../../api/index.js";
const friends = {
  namespaced: true,
  state: {
    friendsStateMenu: "online",
    /*
    친구는 
    online:온라인상태의 친구
    accept:모든 친구
    wait: 친구 요청온 사람
    request: 친구가 되기 위해 요청 건 사람
    ban: 차단한 사람
    으로 구별된다.
    **/
    friendsOnline: [],
    friendsAccept: [],
    friendsWait: [],
    friendsWaitNumber: 0,
    friendsRequest: [],
    friendsBan: [],
    friendsPlusMenu: null,
    friendsReadyToDelete: null,
    friendsReadyToBlock: null,
    friendsProfileModal: null,
    friendsState: [],
  },
  mutations: {
    setAllFriends(state, friendsAccept) {
      state.friendsAccept = friendsAccept;
    },
    setOnlineFriends(state, friendsOnline) {
      state.friendsOnline = friendsOnline;
    },
    setWaitingFriends(state, friendsWait) {
      state.friendsWait = friendsWait;
      state.friendsWaitNumber = friendsWait.length;
    },
    setRequestFriends(state, friendsRequest) {
      state.friendsRequest = friendsRequest;
    },
    setBanFriends(state, friendsBan) {
      state.friendsBan = friendsBan;
    },
    setFriendsStateMenu(state, friendsStateMenu) {
      state.friendsStateMenu = friendsStateMenu;
    },
    setFriendsPlusMenu(state, friendsPlusMenu) {
      state.friendsPlusMenu = friendsPlusMenu;
    },
    setFriendsReadyToDelete(state, friendsReadyToDelete) {
      state.friendsReadyToDelete = friendsReadyToDelete;
    },
    setFriendsReadyToBlock(state, friendsReadyToBlock) {
      state.friendsReadyToBlock = friendsReadyToBlock;
    },
    setFriendsProfileModal(state, friendsProfileModal) {
      state.friendsProfileModal = friendsProfileModal;
    },
    setFriendsState(state, friendsState) {
      state.friendsState = friendsState;
    },
  },
  actions: {
    async FETCH_FRIENDSLIST({ commit }) {
      const result = await fetchFriends();
      let friendsRequest = [];
      let friendsWait = [];
      let friendsAccept = [];
      let friendsBan = [];
      for (var i = 0; i < result.data.result.length; i++) {
        if (result.data.result[i].state == "REQUEST") {
          friendsRequest.push(result.data.result[i]);
        } else if (result.data.result[i].state == "WAIT") {
          friendsWait.push(result.data.result[i]);
        } else if (result.data.result[i].state == "ACCEPT") {
          result.data.result[i].onlineState = "offline";
          friendsAccept.push(result.data.result[i]);
        } else if (result.data.result[i].state == "BAN") {
          friendsBan.push(result.data.result[i]);
        }
      }
      commit("setRequestFriends", friendsRequest);
      commit("setWaitingFriends", friendsWait);
      commit("setAllFriends", friendsAccept);
      commit("setBanFriends", friendsBan);
    },
    async fetchFriendsStates(context) {
      let friendsIds = [];
      for (let i = 0; i < context.state.friendsAccept.length; i++) {
        friendsIds.push(context.state.friendsAccept[i].userId);
      }
      const result = await fetchFriendsState(friendsIds);
      console.log(result.data.result);

      context.commit("setFriendsState", result.data.result);
      let friendsOnline = [];
      for (let j = 0; j < context.state.friendsAccept.length; j++) {
        if (
          result.data.result[context.state.friendsAccept[j].userId] != "offline"
        ) {
          context.state.friendsAccept[j].onlineState =
            result.data.result[context.state.friendsAccept[j].userId];
          friendsOnline.push(context.state.friendsAccept[j]);
        }
      }
      context.commit("setAllFriends", context.state.friendsAccept);
      console.log("friendsOnline", friendsOnline);
      context.commit("setOnlineFriends", friendsOnline);
    },
  },
};

export default friends;
