import { fetchCommunityList } from "../../api/index.js";
const server = {
  namespaced: true,
  state: {
    createServer: false,
    createChannel: false,
    openServerPopout: false,
    categoryInfo: {},
    communityList: [],
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
    setCommunityList(state, communityList) {
      state.communityList = communityList;
    },
  },
  actions: {
    async FETCH_COMMUNITYLIST({ commit }) {
      const result = await fetchCommunityList();
      commit("setCommunityList", result.data.result.communities);
    },
  },
};

export default server;
