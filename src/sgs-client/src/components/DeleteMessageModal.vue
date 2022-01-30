<template>
  <div class="modal" v-if="messageReadyToDelete != ''">
    <div class="blurred-background" @click="exitModal"></div>
    <div class="modal-container">
      <modal @exit="exitModal">
        <template slot="header">
          <h3 class="modal-big-title">메세지 삭제하기</h3>
        </template>
        <template slot="content">
          <div class="modal-subtitle">정말 이 메시지를 삭제하시겠습니까?</div>
        </template>
        <template slot="footer">
          <div class="submit-server-form-footer">
            <button
              type="button"
              class="medium-submit-button"
              @click="deleteMessage(messageReadyToDelete)"
            >
              <div>삭제</div>
            </button>
            <button class="back-button" @click="exitModal">취소</button>
          </div>
        </template>
      </modal>
    </div>
  </div>
</template>

<script>
import { mapState, mapMutations } from "vuex";
import Modal from "./common/Modal.vue";
export default {
  components: { Modal },
  computed: {
    ...mapState("server", ["messageReadyToDelete"]),
    ...mapState("utils", ["stompSocketClient", "stompSocketConnected"]),
  },
  methods: {
    ...mapMutations("server", ["setMessageReadyToDelete"]),
    exitModal() {
      this.setMessageReadyToDelete("");
    },
    deleteMessage() {
      if (this.stompSocketClient && this.stompSocketConnected) {
        const msg = {
          id: this.messageReadyToDelete,
        };
        this.stompSocketClient.send(
          "/kafka/send-channel-delete",
          JSON.stringify(msg),
          {}
        );
      }
    },
  },
};
</script>

<style></style>
