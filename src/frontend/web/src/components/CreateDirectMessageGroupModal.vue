<template>
  <div class="modal" v-if="createDirectMessageGroupModal">
    <div class="blurred-background" @click="closeModal"></div>
    <div class="modal-container">
      <modal @exit="closeModal">
        <template slot="header">
          <h3 class="action-title margin-left-8px">친구 선택하기</h3>
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
                <div class="invite-avatar margin-right-8px position-relative">
                  <img class="avatar" :src="friend.profileImage" alt=" " />
                  <div class="status-ring">
                    <div class="status-offline"></div>
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
import { createDirectMessage } from "../api";
import Modal from "./common/Modal.vue";
import SearchBar from "./common/SearchBar.vue";
export default {
  components: {
    Modal,
    SearchBar,
  },
  data() {
    return {
      checkedFriends: [],
    };
  },
  methods: {
    closeModal() {
      this.setCreateDirectMessageGroupModal(false);
    },
    ...mapMutations("dm", ["setCreateDirectMessageGroupModal"]),
    async createDirectMessageGroup() {
      console.log("friends", this.checkedFriends);
      const dmMembers = {
        members: this.checkedFriends,
      };
      const result = await createDirectMessage(dmMembers);
      this.setCreateDirectMessageGroupModal(false);
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
  background-color: #202225;
  padding: 4px;
  display: flex;
}
.position-relative {
  position: relative;
}
</style>
