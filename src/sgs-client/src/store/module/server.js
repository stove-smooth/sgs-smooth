const server = {
  namespaced: true,
  state: {
    createchannel: false,
    openServerPopout: false,
  },
  mutations: {
    setCreateChannel(state, createchannel) {
      state.createchannel = createchannel;
    },
    setOpenServerPopout(state) {
      state.openServerPopout = !state.openServerPopout;
    },
  },
};

export default server;
