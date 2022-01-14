import { fetchWaitingFriends } from "../../api/index.js";
const friends = {
  namespaced: true,
  state: {
    friendsstatemenu: "online",
    friendsonline: [],
    friendsall: [],
    friendsreceivedwaiting: [],
    friendsreceivedwaitingnumber: 0,
    friendssendwaiting: [],
    friendsblocked: [],
  },
  mutations: {
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
    setFriendsStateMenu(state, friendsstatemenu) {
      state.friendsstatemenu = friendsstatemenu;
    },
  },
  actions: {
    async FETCH_FRIENDSWAITING({ commit }) {
      console.log("친구받아오기");
      const result = await fetchWaitingFriends();
      console.log(result.data.result);
      console.log(commit);
    },
  },
};

export default friends;
