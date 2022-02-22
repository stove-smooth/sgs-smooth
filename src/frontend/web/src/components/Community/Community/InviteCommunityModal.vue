<template>
  <div class="modal">
    <div class="blurred-background" @click="closeModal"></div>
    <div class="modal-container">
      <modal @exit="closeModal" :backgroudColor="blackColor">
        <template slot="header">
          <h3 class="white-action-title margin-left-8px">
            친구를 {{ communityInviteModal.serverName }} 그룹으로 초대하기
          </h3>
        </template>
        <template slot="content">
          <div
            class="invite-scroller thin-scrollbar"
            v-if="inviteeFriends.length > 0"
          >
            <div
              class="invite-row justify-content-space-between align-items-center"
              v-for="(friend, index) in inviteeFriends"
              :key="friend.userId"
            >
              <div class="align-items-center">
                <div class="invite-avatar margin-right-8px">
                  <img class="avatar" :src="friend.profileImage" alt=" " />
                </div>
                <div class="primary-text-content white-color">
                  {{ friend.name }}
                </div>
              </div>
              <button
                class="invite-button"
                @click="inviteFriendToCommunity(friend, index)"
                v-if="friend.isInvited == false"
              >
                <div class="positive-border-color white-space-wrap">
                  초대하기
                </div>
              </button>
              <template v-else><div class="white-color">전송됨</div></template>
            </div>
          </div>
          <div v-else class="primary-text-content white-color">
            초대할 친구가 없습니다.
          </div>
        </template>
        <template slot="footer"
          ><h5 class="margin-left-8px no-margin-bottom white-color">
            또는 친구에게 서버 초대 링크 전송하기
          </h5>
          <div
            class="community-invite-container align-items-center justify-content-center"
          >
            <input id="inviteUrl" :value="this.invitationUrl" />
            <button class="middle-button" @click="copyCommunityUrl">
              복사
            </button>
          </div>
        </template>
      </modal>
    </div>
  </div>
</template>

<script>
import Vue from "vue";
import { mapState, mapMutations, mapActions, mapGetters } from "vuex";
import Modal from "@/components/common/Modal.vue";
import { createInvitation, createDirectMessage } from "@/api/index.js";
export default {
  components: {
    Modal,
  },
  data() {
    return {
      invitationUrl: "",
      blackColor: "#36393f",
      inviteeFriends: [],
    };
  },
  async created() {
    await this.FETCH_FRIENDSLIST();
    let icon;
    for (var i = 0; i < this.communityList.communities.length; i++) {
      if (
        this.communityList.communities[i].id ==
        this.communityInviteModal.serverId
      ) {
        icon = this.communityList.communities[i].icon;
        break;
      }
    }
    const invitationData = {
      id: this.communityInviteModal.serverId,
      icon: icon,
    };
    const result = await createInvitation(invitationData);
    this.invitationUrl = result.data.result.url;
    //초대대상을 정합니다.
    let friendsMember = this.friendsAccept;
    let communityMember = this.communityOnlineMemberList.concat(
      this.communityOfflineMemberList
    );
    for (let i = 0; i < friendsMember.length; i++) {
      for (let j = 0; j < communityMember.length; j++) {
        if (friendsMember[i] != "해당안됨") {
          if (friendsMember[i].userId == communityMember[j].id) {
            friendsMember[i] = "해당안됨";
          }
        }
      }
    }
    this.inviteeFriends = friendsMember.filter(
      (element) => element !== "해당안됨"
    );
    for (let i = 0; i < this.inviteeFriends.length; i++) {
      Vue.set(this.inviteeFriends[i], "isInvited", false);
    }
  },
  computed: {
    ...mapState("community", [
      "communityInviteModal",
      "communityList",
      "communityOnlineMemberList",
      "communityOfflineMemberList",
    ]),
    ...mapState("friends", ["friendsAccept"]),
    ...mapState("utils", ["stompSocketClient", "stompSocketConnected"]),
    ...mapGetters("user", ["getUserId"]),
    ...mapState("user", ["nickname", "userimage"]),
  },
  methods: {
    ...mapActions("friends", ["FETCH_FRIENDSLIST"]),
    ...mapMutations("community", ["setCommunityInviteModal"]),
    closeModal() {
      this.setCommunityInviteModal(false);
    },
    copyCommunityUrl() {
      const copyText = document.getElementById("inviteUrl");
      copyText.select();
      document.execCommand("copy");
      this.$swal.fire({
        title: copyText.value + "을 복사했습니다.",
      });
    },
    async inviteFriendToCommunity(friend, index) {
      const dmMembers = {
        members: [friend.userId],
      };
      const result = await createDirectMessage(dmMembers);
      const msg = {
        content: `<~inviting~>${this.invitationUrl}`,
        channelId: result.data.result.id,
        userId: this.getUserId,
        name: this.nickname,
        profileImage: this.userimage,
      };
      this.stompSocketClient.send(
        "/kafka/send-direct-message",
        JSON.stringify(msg),
        {}
      );
      this.inviteeFriends[index].isInvited = true;
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
  justify-content: space-between;
}
.white-action-title {
  font-weight: 700;
  overflow: hidden;
  text-overflow: ellipsis;
  font-size: 16px;
  line-height: 20px;
  color: #fff;
}
.white-space-wrap {
  white-space: nowrap;
}
#inviteUrl {
  color: white;
  background: none;
  border: none;
}
</style>
