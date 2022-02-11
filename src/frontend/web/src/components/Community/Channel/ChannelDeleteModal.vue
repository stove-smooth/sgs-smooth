<template>
  <div class="modal" v-if="channelReadyToDelete">
    <div class="blurred-background" @click="exitModal"></div>
    <div class="modal-container">
      <modal @exit="exitModal">
        <template slot="header">
          <h3 class="modal-big-title">채널 삭제</h3>
        </template>
        <template slot="content">
          <div class="modal-subtitle">
            정말 {{ channelReadyToDelete.name }} 채널을 삭제할까요? 삭제하면
            되돌릴 수 없어요.
          </div>
        </template>
        <template slot="footer">
          <div class="submit-server-form-footer">
            <button
              type="button"
              class="medium-submit-button"
              @click="deleteChannel(channelReadyToDelete.id)"
            >
              <div>채널 삭제</div>
            </button>
            <button class="back-button" @click="exitModal">취소</button>
          </div>
        </template>
      </modal>
    </div>
  </div>
</template>

<script>
import Modal from "@/components/common/Modal.vue";
import { mapState, mapMutations } from "vuex";
import { deleteChannel } from "@/api";
export default {
  components: { Modal },
  computed: {
    ...mapState("server", ["channelReadyToDelete", "communityInfo"]),
  },
  methods: {
    ...mapMutations("server", [
      "setChannelReadyToDelete",
      "setChannelSettingModal",
    ]),
    exitModal() {
      this.setChannelReadyToDelete(null);
    },
    async deleteChannel(channelId) {
      try {
        await deleteChannel(channelId);
        this.setChannelReadyToDelete(null);
        this.setChannelSettingModal(null);
        const categories = this.communityInfo.categories;
        for (var category in categories) {
          if (categories[category].channels != null) {
            let array = categories[category].channels.filter(
              (element) => element.id !== channelId
            );
            categories[category].channels = array;
          }
        }
      } catch (err) {
        console.log(err.response, "에러");
      }
    },
  },
};
</script>

<style></style>
