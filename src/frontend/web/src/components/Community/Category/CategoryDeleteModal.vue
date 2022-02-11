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
    async deleteCategory(categoryId) {
      let tempCommunityInfo = this.communityInfo;
      await deleteCategory(categoryId);
      let array = this.communityInfo.categories.filter(
        (element) => element.id !== categoryId
      );
      tempCommunityInfo.categories = array;
      this.setCategoryReadyToDelete(false);
      this.setCategorySettingModal(false);
    },
  },
};
</script>

<style></style>
