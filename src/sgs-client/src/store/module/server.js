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
    openServerPopout: null,
    categoryReadyToDelete: false,
    communityList: [],
    communityInfo: null,
    communityOnlineMemberList: [],
    communityOfflineMemberList: [],
    serverSettingModal: null,
  },
  mutations: {
    setCreateServer(state, createServer) {
      state.createServer = createServer;
    },
    setCreateChannel(state, createChannel) {
      state.createChannel = createChannel;
    },
    setOpenServerPopout(state, openServerPopout) {
      state.openServerPopout = openServerPopout;
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
    setCategoryReadyToDelete(state, categoryReadyToDelete) {
      state.categoryReadyToDelete = categoryReadyToDelete;
    },
    setServerSettingModal(state, serverSettingModal) {
      state.serverSettingModal = serverSettingModal;
    },
  },
  actions: {
    async FETCH_COMMUNITYLIST({ commit }) {
      const result = await fetchCommunityList();
      commit("setCommunityList", result.data.result.communities);
    },
    async FETCH_COMMUNITYINFO({ commit }, serverid) {
      const result = await fetchCommunityInfo(serverid);
      commit("setCommunityInfo", result.data.result);
    },
    async FETCH_COMMUNITYMEMBERLIST({ commit }, serverid) {
      const result = await fetchCommunityMemberList(serverid);
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
