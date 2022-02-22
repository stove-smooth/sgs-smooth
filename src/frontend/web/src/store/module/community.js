import {
  fetchCommunityList,
  fetchCommunityInfo,
  fetchCommunityMemberList,
} from "../../api/index.js";
import user from "./user.js";
const community = {
  namespaced: true,
  state: {
    //커뮤니티
    createCommunity: false,
    openCommunityPopout: null,
    communityReadyToDelete: false,
    communityReadyToExit: false,
    communityReadyToBanish: false,
    communityList: null,
    communityInfo: null,
    communityOnlineMemberList: [],
    communityOfflineMemberList: [],
    communitySettingModal: null,
    communityInviteModal: false,
    communityOwner: false,
    communityMessageReplyId: "",
    communityMemberPlusMenu: null,

    //카테고리
    createCategory: false,
    categorySettingModal: false,
    categoryReadyToDelete: false,

    //채널
    createChannel: false,
    channelSettingModal: false,
    channelReadyToDelete: false,

    //메시지
    messagePlusMenu: null,
    messageEditId: "",
    messageFixId: "",
    openFixedMessagesModal: false,
    messageReadyToDelete: false,

    //현재 위치한 채널 타입
    currentChannelType: null,
  },
  getters: {
    getCommunityList: (state) => {
      return state.communityList;
    },
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
      await commit("setCommunityList", result.data.result);
    },
    async FETCH_COMMUNITYINFO({ commit }, serverid) {
      const result = await fetchCommunityInfo(serverid);
      await commit("setCommunityInfo", result.data.result);
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
          console.log("homehome");
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
