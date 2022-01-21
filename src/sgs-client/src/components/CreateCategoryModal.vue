<template>
  <div class="modal" v-if="createCategory">
    <div class="blurred-background" @click="closeModal"></div>
    <div class="modal-container">
      <modal @exit="closeModal">
        <template slot="header">
          <h3 class="modal-big-title no-margin-bottom">카테고리 만들기</h3>
          <div class="create-category-modal">
            <form>
              <div class="server-name-input-container">
                <h5 class="label-id" v-bind:style="{ color: 'black' }">
                  카테고리 이름
                </h5>
                <div
                  class="friends-state-text"
                  v-bind:style="{ position: 'relative' }"
                >
                  <input
                    width="100%"
                    type="text"
                    placeholder="새로운 카테고리"
                    maxlength="100"
                    v-model="categoryName"
                    class="channel-name-input"
                  />
                </div>
              </div>
            </form>
          </div>
        </template>
        <template slot="content"></template>
        <template slot="footer">
          <div class="submit-server-form-footer">
            <button
              :disabled="!categoryName"
              type="button"
              class="medium-submit-button"
              @click="createNewCategory"
            >
              <div>카테고리 만들기</div>
            </button>
            <button class="back-button" @click="closeModal">취소</button>
          </div>
        </template>
      </modal>
    </div>
  </div>
</template>

<script>
import { mapState, mapMutations } from "vuex";
import Modal from "../components/common/Modal.vue";
import { createNewCategory } from "../api/index.js";
export default {
  components: {
    Modal,
  },
  data() {
    return {
      categoryName: "",
    };
  },
  computed: {
    ...mapState("server", ["createCategory"]),
  },
  methods: {
    ...mapMutations("server", ["setCreateCategory"]),
    closeModal() {
      this.setCreateCategory(false);
    },
    async createNewCategory() {
      const categoryData = {
        communityId: this.createCategory.serverId,
        name: this.categoryName,
        public: true,
        members: null,
      };
      try {
        await createNewCategory(categoryData);
        window.location.reload();
      } catch (err) {
        console.log(err.response);
      }
    },
  },
};
</script>

<style scoped>
.create-category-modal {
  padding: 0 8px 8px 16px;
}
</style>
