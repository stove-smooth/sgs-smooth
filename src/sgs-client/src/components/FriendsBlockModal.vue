<template>
  <div class="modal" v-if="friendsreadytoblock">
    <div class="blurred-background" @click="exitModal"></div>
    <div class="modal-container">
      <modal @exit="exitModal">
        <template slot="header">
          <h3 class="modal-big-title">
            {{ friendsreadytoblock.username }}님을 차단하기
          </h3>
        </template>
        <template slot="content">
          <div class="modal-subtitle">
            친구 {{ friendsreadytoblock.username }}님을 차단하시겠어요?
          </div>
        </template>
        <template slot="footer">
          <div class="submit-server-form-footer">
            <button
              type="button"
              class="medium-submit-button"
              @click="blockFriends(friendsreadytoblock.id)"
            >
              <div>친구 차단하기</div>
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
import { blockFriend } from "../api/index.js";
export default {
  components: { Modal },
  computed: {
    ...mapState("friends", ["friendsreadytoblock"]),
  },
  methods: {
    ...mapMutations("friends", ["setFriendsReadyToBlock"]),
    exitModal() {
      this.setFriendsReadyToBlock(null);
    },
    async blockFriends(userId) {
      const result = await blockFriend(userId);
      console.log(result);
    },
  },
};
</script>

<style></style>
