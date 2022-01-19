import {
  fetchCommunityList,
  fetchCommunityInfo,
  fetchCommunityMemberList,
} from "../../api/index.js";
const server = {
  namespaced: true,
  state: {
    createServer: false,
    createChannel: false,
    createCategory: false,
    categorySettingModal: false,
    openServerPopout: false,
    categoryInfo: {},
    communityList: [],
    communityInfo: null,
    communityOnlineMemberList: [],
    communityOfflineMemberList: [],
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
    setCommunityOnlineMemberList(state, communityOnlineMemberList) {
      state.communityOnlineMemberList = communityOnlineMemberList;
    },
    setCommunityOfflineMemberList(state, communityOfflineMemberList) {
      state.communityOfflineMemberList = communityOfflineMemberList;
    },
    setCreateCategory(state, createCategory) {
      state.createCategory = createCategory;
    },
    setCategorySettingModal(state, categorySettingModal) {
      state.categorySettingModal = categorySettingModal;
    },
  },
  actions: {
    async FETCH_COMMUNITYLIST({ commit }) {
      const result = await fetchCommunityList();
      commit("setCommunityList", result.data.result.communities);
    },
    async FETCH_COMMUNITYINFO({ commit }, serverid) {
      const result = await fetchCommunityInfo(serverid);
      console.log("펫치커뮤니티정보", result.data.result);
      commit("setCommunityInfo", result.data.result);
    },
    async FETCH_COMMUNITYMEMBERLIST({ commit }, serverid) {
      const result = await fetchCommunityMemberList(serverid);
      console.log(result.data.result.members);
      let onlineMembers = [];
      let offlineMembers = [];
      for (var i = 0; i < result.data.result.members.length; i++) {
        if (result.data.result.members[i].status === "online") {
          onlineMembers.push(result.data.result.members[i]);
        } else {
          offlineMembers.push(result.data.result.members[i]);
        }
      }
      await commit("setCommunityOnlineMemberList", onlineMembers);
      await commit("setCommunityOfflineMemberList", offlineMembers);
    },
  },
};

export default server;
