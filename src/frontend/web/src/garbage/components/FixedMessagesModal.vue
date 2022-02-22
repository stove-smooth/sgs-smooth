<template>
  <div class="modal" v-if="openFixedMessagesModal !== false">
    <div class="blurred-background" @click="exitModal"></div>
    <div class="modal-container">
      <modal @exit="exitModal">
        <template slot="header">
          <h3 class="modal-big-title">잘 보이게 고정해주세요.</h3>
        </template>
        <template slot="content">
          <ol class="scroller-inner fixed-message-container">
            <div class="invite-scroller thin-scrollbar">
              <div v-for="(item, index) in 10" :key="index">
                <li class="chat-message-wrapper fixed-message-wrapper">
                  <div
                    class="primary-chat-message-wrapper others-chat-message-wrapper"
                  >
                    <div class="chat-message-content">
                      <img
                        :src="item.profileImage"
                        class="chat-avatar clickable"
                        alt="image"
                      />
                      <h2 class="chat-avatar-header">
                        <span class="chat-user-name">name</span>
                        <span class="chat-time-stamp">time</span>
                      </h2>
                      <div class="message-content">
                        안녕하세요 저는 바뷰에요.
                      </div>
                    </div>
                  </div>
                </li>
              </div>
            </div>
          </ol>
        </template>
      </modal>
    </div>
  </div>
</template>

<script>
import { mapState, mapMutations } from "vuex";
import Modal from "../../components/common/Modal.vue";
export default {
  components: { Modal },
  computed: {
    ...mapState("community", ["openFixedMessagesModal"]),
  },
  methods: {
    ...mapMutations("community", ["setOpenFixedMessagesModal"]),
    exitModal() {
      this.setOpenFixedMessagesModal(false);
    },
  },
};
</script>

<style>
.fixed-message-container {
  background-color: var(--dark-grey-color);
}
.fixed-message-wrapper {
  background-color: #36393f;
  border: 8px;
}
</style>
