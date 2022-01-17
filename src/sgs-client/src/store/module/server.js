const server = {
  namespaced: true,
  state: {
    createServer: false,
    createChannel: false,
    openServerPopout: false,
    categoryInfo: {},
  },
  mutations: {
    setCreateServer(state, createServer) {
      state.createServer = createServer;
    },
    setCreateChannel(state, createChannel) {
      state.createChannel = createChannel;
    },
    setOpenServerPopout(state) {
      state.openServerPopout = !state.openServerPopout;
    },
    setCategoryInfo(state, categoryInfo) {
      state.categoryInfo = categoryInfo;
    },
  },
};

export default server;
