import { fetchFriends } from "../../api/index.js";
const friends = {
  namespaced: true,
  state: {
    friendsStateMenu: "online",
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
  },
  mutations: {
    setAllFriends(state, friendsAccept) {
      state.friendsAccept = friendsAccept;
    },
    setOnlineFriends(state) {
      state.friendsOnline = "";
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
          friendsAccept.push(result.data.result[i]);
        } else if (result.data.result[i].state == "BAN") {
          friendsBan.push(result.data.result[i]);
        }
      }
      console.log("친구", friendsAccept, friendsAccept);
      commit("setRequestFriends", friendsRequest);
      commit("setWaitingFriends", friendsWait);
      commit("setAllFriends", friendsAccept);
      commit("setBanFriends", friendsBan);
      console.log("state", this.state.friendsAccept);
    },
  },
};

export default friends;
