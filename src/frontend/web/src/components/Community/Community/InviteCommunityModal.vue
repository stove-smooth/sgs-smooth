<template>
  <div class="modal">
    <div class="blurred-background" @click="closeModal"></div>
    <div class="modal-container">
      <modal @exit="closeModal">
        <template slot="header">
          <h3 class="action-title margin-left-8px">
            친구를 {{ communityInviteModal.serverName }} 그룹으로 초대하기
          </h3>
          <search-bar></search-bar>
        </template>
        <template slot="content">
          <div class="invite-scroller thin-scrollbar">
            <div
              class="invite-row justify-content-space-between align-items-center"
              v-for="friend in friendsAccept"
              :key="friend.id"
            >
              <div class="align-items-center">
                <div class="invite-avatar margin-right-8px">
                  <img class="avatar" :src="friend.profileImage" alt=" " />
                </div>
                <div class="primary-text-content">{{ friend.name }}</div>
              </div>
              <button class="invite-button positive-border-color">
                <div class="primary-text-content">초대하기</div>
              </button>
            </div>
          </div>
        </template>
        <template slot="footer"
          ><h5 class="margin-left-8px no-margin-bottom">
            또는 친구에게 서버 초대 링크 전송하기
          </h5>
          <div
            class="community-invite-container align-items-center justify-content-center"
          >
            <div class="server-link-wrapper">{{ this.invitationUrl }}</div>
            <button class="middle-button">복사</button>
          </div>
        </template>
      </modal>
    </div>
  </div>
</template>

<script>
import { mapState, mapMutations, mapActions } from "vuex";
import Modal from "@/components/common/Modal.vue";
import SearchBar from "@/components/common/SearchBar.vue";
import { createInvitation } from "@/api/index.js";
export default {
  components: {
    Modal,
    SearchBar,
  },
  data() {
    return {
      invitationUrl: "",
    };
  },
  async created() {
    await this.FETCH_FRIENDSLIST();
    let icon;
    for (var i = 0; i < this.communityList.length; i++) {
      if (this.communityList[i].id == this.communityInviteModal.serverId) {
        icon = this.communityList[i].icon;
        break;
      }
    }
    const invitationData = {
      id: this.communityInviteModal.serverId,
      icon: icon,
    };
    const result = await createInvitation(invitationData);
    this.invitationUrl = result.data.result.url;
  },
  computed: {
    ...mapState("community", ["communityInviteModal", "communityList"]),
    ...mapState("friends", ["friendsAccept"]),
  },
  methods: {
    ...mapActions("friends", ["FETCH_FRIENDSLIST"]),
    ...mapMutations("community", ["setCommunityInviteModal"]),
    closeModal() {
      this.setCommunityInviteModal(false);
    },
  },
};
</script>

<style>
.invite-scroller {
  max-height: 200px;
  overflow: hidden scroll;
  border-bottom: 1px solid;
  border-top: 1px solid;
}
.invite-row {
  box-sizing: border-box;
  border-radius: 3px;
  margin-right: -10px;
  padding: 7px 10px 7px 8px;
  height: 44px;
}
.invite-button {
  color: #58f287;
  height: 32px;
  flex: none;
  width: 72px;
  min-width: 60px;
  min-height: 32px;
  border-width: 1px;
  border-style: solid;
  border-radius: 3px;
  font-size: 14px;
  font-weight: 500;
  line-height: 16px;
  padding: 2px 16px;
  display: flex;
  justify-content: center;
  align-items: center;
  position: relative;
  background: none;
}
.invite-avatar {
  width: 32px;
  height: 32px;
  margin-right: 10px;
}
.community-invite-container {
  font-size: 16px;
  box-sizing: border-box;
  border-radius: 3px;
  color: #dcddde;
  background-color: #2f3136;
  border: 1px solid rgba(0, 0, 0, 0.3);
  margin: 8px;
}
.server-link-wrapper {
  box-sizing: border-box;
  width: 100%;
  border-radius: 3px;
  color: #dcddde;
  background-color: rgba(0, 0, 0, 0.1);
  font-size: 16px;
  padding: 10px;
  height: 40px;
}
</style>
