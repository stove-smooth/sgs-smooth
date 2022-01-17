const server = {
  namespaced: true,
  state: {
    createserver: false,
    createchannel: false,
    openServerPopout: false,
    categoryInfo: {},
  },
  mutations: {
    setCreateServer(state, createserver) {
      state.createserver = createserver;
    },
    setCreateChannel(state, createchannel) {
      state.createchannel = createchannel;
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
