import { fetchCommunityList, fetchCommunityInfo } from "../../api/index.js";
const server = {
  namespaced: true,
  state: {
    createServer: false,
    createChannel: false,
    openServerPopout: false,
    categoryInfo: {},
    communityList: [],
    communityInfo: null,
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
    setCommunityInfo(state, communityInfo) {
      state.communityInfo = communityInfo;
    },
  },
  actions: {
    async FETCH_COMMUNITYLIST({ commit }) {
      const result = await fetchCommunityList();
      commit("setCommunityList", result.data.result.communities);
    },
    async FETCH_COMMUNITYINFO({ commit }, serverid) {
      const result = await fetchCommunityInfo(serverid);
      console.log(result.data.result);
      commit("setCommunityInfo", result.data.result);
    },
  },
};

export default server;
