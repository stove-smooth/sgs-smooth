const server = {
  namespaced: true,
  state: {
    createchannel: false,
  },
  mutations: {
    setCreateChannel(state, createchannel) {
      state.createchannel = createchannel;
    },
  },
};

export default server;
