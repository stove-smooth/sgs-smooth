import { fetchFriends } from "../../api/index.js";
const friends = {
  namespaced: true,
  state: {
    friendsstatemenu: "online",
    friendsonline: [],
    friendsaccept: [],
    friendswait: [],
    friendswaitnumber: 0,
    friendsrequest: [],
    friendsban: [],
  },
  mutations: {
    setAllFriends(state, friendsaccept) {
      state.friendsaccept = friendsaccept;
    },
    setOnlineFriends(state) {
      state.friendsonline = "";
    },
    setWaitingFriends(state, friendswait) {
      state.friendswait = friendswait;
      state.friendswaitnumber = friendswait.length;
    },
    setRequestFriends(state, friendsrequest) {
      state.friendsrequest = friendsrequest;
    },
    setBanFriends(state, friendsban) {
      state.friendsban = friendsban;
    },
    setFriendsStateMenu(state, friendsstatemenu) {
      state.friendsstatemenu = friendsstatemenu;
    },
  },
  actions: {
    async FETCH_FRIENDSLIST({ commit }) {
      console.log("친구받아오기");
      const result = await fetchFriends();
      let friendsrequest = [];
      let friendswait = [];
      let friendsaccept = [];
      let friendsban = [];
      for (var i = 0; i < result.data.result.length; i++) {
        if (result.data.result[i].state == "REQUEST") {
          friendsrequest.push(result.data.result[i]);
        } else if (result.data.result[i].state == "WAIT") {
          friendswait.push(result.data.result[i]);
        } else if (result.data.result[i].state == "ACCEPT") {
          friendsaccept.push(result.data.result[i]);
        } else if (result.data.result[i].state == "BAN") {
          friendsban.push(result.data.result[i]);
        }
      }
      commit("setRequestFriends", friendsrequest);
      commit("setWaitingFriends", friendswait);
      commit("setAllFriends", friendsaccept);
      commit("setBanFriends", friendsban);
      console.log(friendsrequest);
    },
  },
};

export default friends;
