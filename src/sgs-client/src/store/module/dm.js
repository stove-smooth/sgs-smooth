const dm = {
  namespaced: true,
  state: {
    directMessageReplyId: "",
  },

  mutations: {
    setDirectMessageReplyId(state, directMessageReplyId) {
      state.directMessageReplyId = directMessageReplyId;
    },
  },
};

export default dm;
