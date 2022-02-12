<template>
  <div class="modal" v-if="categoryReadyToDelete">
    <div class="blurred-background" @click="exitModal"></div>
    <div class="modal-container">
      <modal @exit="exitModal">
        <template slot="header">
          <h3 class="modal-big-title">카테고리 삭제</h3>
        </template>
        <template slot="content">
          <div class="modal-subtitle">
            정말 {{ categoryReadyToDelete.categoryName }} 채널을 삭제할까요?
            삭제하면 되돌릴 수 없어요.
          </div>
        </template>
        <template slot="footer">
          <div class="submit-server-form-footer">
            <button
              type="button"
              class="medium-submit-button"
              @click="deleteCategory(categoryReadyToDelete.categoryId)"
            >
              <div>카테고리 삭제</div>
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
import { deleteCategory } from "@/api/index.js";
export default {
  components: { Modal },
  computed: {
    ...mapState("server", ["categoryReadyToDelete", "communityInfo"]),
  },
  methods: {
    ...mapMutations("server", [
      "setCategoryReadyToDelete",
      "setCategorySettingModal",
      "setCommunityInfo",
    ]),
    exitModal() {
      this.setCategoryReadyToDelete(false);
    },
    async updateCommunityInfo(categoryId) {
      let tempCommunityInfo = this.communityInfo;
      await deleteCategory(categoryId);
      let array = this.communityInfo.categories.filter(
        (element) => element.id !== categoryId
      );
      tempCommunityInfo.categories = array;
      this.setCategoryReadyToDelete(false);
      this.setCategorySettingModal(false);
    },
    async deleteCategory(categoryId) {
      const categories = this.communityInfo.categories;
      //본인이 위치한 카테고리를 삭제할 경우 서버에 재접한다.
      for (var category in categories) {
        if (categories[category].channels != null) {
          for (let i = 0; i < categories[category].channels.length; i++) {
            if (
              categories[category].channels[i].id ==
              this.$route.params.channelid
            ) {
              if (categories[category].channels[i].categoryId == categoryId) {
                await this.updateCommunityInfo(categoryId);
                this.$router.push(`/channels/${this.$route.params.serverid}`);
                return;
              }
            }
          }
        }
      }
      //커뮤니티에 카테고리 삭제를 반영한다.
      await this.updateCommunityInfo(categoryId);
    },
  },
};
</script>

<style></style>
