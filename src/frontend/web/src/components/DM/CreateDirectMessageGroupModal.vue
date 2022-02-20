<template>
  <div class="modal" v-if="createDirectMessageGroupModal">
    <div class="blurred-background" @click="closeModal"></div>
    <div class="modal-container">
      <modal @exit="closeModal">
        <template slot="header">
          <h3 class="action-title margin-left-8px">친구 선택하기</h3>
        </template>
        <template slot="content">
          <div class="invite-scroller thin-scrollbar">
            <div
              class="invite-row justify-content-space-between align-items-center"
              v-for="friend in friendsAccept"
              :key="friend.id"
            >
              <div class="align-items-center">
                <div class="invite-avatar margin-right-8px position-relative">
                  <img class="avatar" :src="friend.profileImage" alt=" " />
                  <div class="status-ring">
                    <template v-if="friend.onlineState == 'offline'"
                      ><div class="status-offline"
                    /></template>
                    <template v-else><div class="status-online" /></template>
                  </div>
                </div>
                <div class="primary-text-content">{{ friend.name }}</div>

                <span class="user-code">#{{ friend.code }}</span>
              </div>
              <input
                type="checkbox"
                v-model="checkedFriends"
                :value="friend.userId"
              />
            </div>
          </div>
        </template>
        <template slot="footer">
          <div class="createGroupDMButtonWrapper">
            <div class="large-button" @click="createDirectMessageGroup">
              새로운 그룹 메시지 만들기
            </div>
          </div>
        </template>
      </modal>
    </div>
  </div>
</template>

<script>
import { mapState, mapMutations } from "vuex";
import { createDirectMessage } from "../../api";
import Modal from "../common/Modal.vue";
export default {
  components: {
    Modal,
  },
  data() {
    return {
      checkedFriends: [],
    };
  },
  methods: {
    closeModal() {
      this.setCreateDirectMessageGroupModal(false);
      this.checkedFriends = [];
    },
    ...mapMutations("dm", ["setCreateDirectMessageGroupModal"]),
    async createDirectMessageGroup() {
      const dmMembers = {
        members: this.checkedFriends,
      };
      const result = await createDirectMessage(dmMembers);
      this.setCreateDirectMessageGroupModal(false);
      this.checkedFriends = [];
      this.$router.push(`/channels/@me/${result.data.result.id}`);
    },
  },
  computed: {
    ...mapState("dm", ["createDirectMessageGroupModal"]),
    ...mapState("friends", ["friendsAccept"]),
  },
};
</script>

<style>
.createGroupDMButtonWrapper {
  padding: 4px;
  display: flex;
}
</style>
