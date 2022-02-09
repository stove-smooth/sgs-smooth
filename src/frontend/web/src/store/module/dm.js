import { fetchDirectMessageList } from "../../api";
const dm = {
  namespaced: true,
  state: {
    directMessageReplyId: "",
    directMessageReadyToDelete: false,
    directMessageList: [],
  },

  mutations: {
    setDirectMessageReplyId(state, directMessageReplyId) {
      state.directMessageReplyId = directMessageReplyId;
    },
    setDirectMessageReadyToDelete(state, directMessageReadyToDelete) {
      state.directMessageReadyToDelete = directMessageReadyToDelete;
    },
    setDirectMessageList(state, directMessageList) {
      state.directMessageList = directMessageList;
    },
  },
  actions: {
    async fetchDirectMessageList({ commit }) {
      let result = await fetchDirectMessageList();
      console.log("결과", result, commit);
      commit("setDirectMessageList", result.data.result.rooms);
    },
  },
};

export default dm;
