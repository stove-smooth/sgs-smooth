import {
  fetchDirectMessageList,
  fetchDirectMessageMemberList,
} from "../../api";
const dm = {
  namespaced: true,
  state: {
    directMessageReplyId: "",
    directMessageReadyToDelete: false,
    directMessageList: [],
    createDirectMessageGroupModal: false,
    directMessageMemberList: [],
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
    setCreateDirectMessageGroupModal(state, createDirectMessageGroupModal) {
      state.createDirectMessageGroupModal = createDirectMessageGroupModal;
    },
    setDirectMessageMemberList(state, directMessageMemberList) {
      state.directMessageMemberList = directMessageMemberList;
    },
  },
  actions: {
    async fetchDirectMessageList({ commit }) {
      let result = await fetchDirectMessageList();
      commit("setDirectMessageList", result.data.result.rooms);
    },
    async fetchDirectMessageMemberList({ commit }, roomId) {
      let result = await fetchDirectMessageMemberList(roomId);
      console.log("결과", result, commit);
    },
  },
};

export default dm;
