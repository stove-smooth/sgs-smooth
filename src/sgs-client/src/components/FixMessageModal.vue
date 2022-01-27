<template>
  <div class="modal" v-if="messageFixId">
    <div class="blurred-background" @click="exitModal"></div>
    <div class="modal-container">
      <modal @exit="exitModal">
        <template slot="header">
          <h3 class="modal-big-title">잘 보이게 고정해주세요.</h3>
        </template>
        <template slot="content">
          <div class="modal-subtitle">
            정말로 이 메시지를 채널에 고정하고 싶은지 다시 한 번 생각해 주세요.
          </div>
        </template>
        <template slot="footer">
          <div class="submit-server-form-footer">
            <button type="button" class="medium-submit-button">
              <div>네, 고정해요.</div>
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
export default {
  computed: {
    ...mapState("server", ["messageFixId"]),
  },
  methods: {
    ...mapMutations("server", ["setMessageFixId"]),
    exitModal() {
      this.setMessageFixId("");
    },
  },
};
</script>

<style></style>
