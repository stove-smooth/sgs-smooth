import {
  fetchCommunityList,
  fetchCommunityInfo,
  fetchCommunityMemberList,
} from "../../api/index.js";
import user from "./user.js";
const community = {
  namespaced: true,
  state: {
    createCommunity: false,
    createChannel: false,
    createCategory: false,
    categorySettingModal: false,
    channelSettingModal: false,
    openCommunityPopout: null,
    categoryReadyToDelete: false,
    communityReadyToDelete: false,
    channelReadyToDelete: false,
    communityReadyToExit: false,
    communityReadyToBanish: false,
    communityList: [],
    communityInfo: null,
    communityOnlineMemberList: [],
    communityOfflineMemberList: [],
    communitySettingModal: null,
    messagePlusMenu: null,
    communityInviteModal: false,
    communityOwner: false,
    communityMessageReplyId: "",
    messageEditId: "",
    messageFixId: "",
    openFixedMessagesModal: false,
    communityMemberPlusMenu: null,
    messageReadyToDelete: false,
    currentChannelType: null,
  },
  mutations: {
    setCreateCommunity(state, createCommunity) {
      state.createCommunity = createCommunity;
    },
    setCreateChannel(state, createChannel) {
      state.createChannel = createChannel;
    },
    setOpenCommunityPopout(state, openCommunityPopout) {
      state.openCommunityPopout = openCommunityPopout;
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
    setCommunityReadyToDelete(state, communityReadyToDelete) {
      state.communityReadyToDelete = communityReadyToDelete;
    },
    setChannelReadyToDelete(state, channelReadyToDelete) {
      state.channelReadyToDelete = channelReadyToDelete;
    },
    setCommunitySettingModal(state, communitySettingModal) {
      state.communitySettingModal = communitySettingModal;
    },
    setChannelSettingModal(state, channelSettingModal) {
      state.channelSettingModal = channelSettingModal;
    },
    setMessagePlusMenu(state, messagePlusMenu) {
      state.messagePlusMenu = messagePlusMenu;
    },
    setCommunityInviteModal(state, communityInviteModal) {
      state.communityInviteModal = communityInviteModal;
    },
    setCommunityOwner(state, communityOwner) {
      state.communityOwner = communityOwner;
    },
    setCommunityReadyToExit(state, communityReadyToExit) {
      state.communityReadyToExit = communityReadyToExit;
    },
    setCommunityReadyToBanish(state, communityReadyToBanish) {
      state.communityReadyToBanish = communityReadyToBanish;
    },
    setCommunityMessageReplyId(state, communityMessageReplyId) {
      state.communityMessageReplyId = communityMessageReplyId;
    },
    setMessageEditId(state, messageEditId) {
      state.messageEditId = messageEditId;
    },
    setMessageFixId(state, messageFixId) {
      state.messageFixId = messageFixId;
    },
    setOpenFixedMessagesModal(state, openFixedMessagesModal) {
      state.openFixedMessagesModal = openFixedMessagesModal;
    },
    setCommunityMemberPlusMenu(state, communityMemberPlusMenu) {
      state.communityMemberPlusMenu = communityMemberPlusMenu;
    },
    setMessageReadyToDelete(state, messageReadyToDelete) {
      state.messageReadyToDelete = messageReadyToDelete;
    },
    setCurrentChannelType(state, currentChannelType) {
      state.currentChannelType = currentChannelType;
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
        const userId = user.state.userId;
        if (
          result.data.result.members[i].role === "OWNER" &&
          result.data.result.members[i].id == userId
        ) {
          await commit("setCommunityOwner", true);
        } else {
          await commit("setCommunityOwner", false);
        }

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

export default community;
