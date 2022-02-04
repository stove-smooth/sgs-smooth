<template>
  <div class="modal" v-if="friendsReadyToDelete">
    <div class="blurred-background" @click="exitModal"></div>
    <div class="modal-container">
      <modal @exit="exitModal">
        <template slot="header">
          <h3 class="modal-big-title">
            {{ friendsReadyToDelete.username }}님을 제거하기
          </h3>
        </template>
        <template slot="content">
          <div class="modal-subtitle">
            친구 {{ friendsReadyToDelete.username }}님을 삭제하시겠어요?
          </div>
        </template>
        <template slot="footer">
          <div class="submit-server-form-footer">
            <button
              type="button"
              class="medium-submit-button"
              @click="deleteFriends(friendsReadyToDelete.id)"
            >
              <div>친구 삭제하기</div>
            </button>
            <button class="back-button" @click="exitModal">취소</button>
          </div>
        </template>
      </modal>
    </div>
  </div>
</template>

<script>
import Modal from "./common/Modal.vue";
import { mapState, mapMutations } from "vuex";
import { deleteFriend } from "../api/index.js";
export default {
  components: { Modal },
  computed: {
    ...mapState("friends", ["friendsReadyToDelete"]),
  },
  methods: {
    ...mapMutations("friends", ["setFriendsReadyToDelete"]),
    exitModal() {
      this.setFriendsReadyToDelete(null);
    },
    async deleteFriends(userId) {
      await deleteFriend(userId);
      window.location.reload();
      this.setFriendsReadyToDelete(null);
    },
  },
};
</script>

<style></style>
