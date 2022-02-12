<template>
  <div class="modal" v-if="categorySettingModal">
    <div
      class="blurred-background"
      @click="setCategorySettingModal(false)"
    ></div>
    <setting-modal>
      <template slot="setting-sidebar">
        <div class="channel-default-container">
          <div class="channel-content-wrapper" role="listitem">
            <div class="channel-content margin-right-8px channel-content-hover">
              <div class="channel-main-content">
                <div class="channel-name-wrapper">
                  <div
                    class="primary-text-content white-color text-align-center font-size-14px"
                  >
                    카테고리 편집
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="primary-seperator"></div>
          <div class="channel-content-wrapper" role="listitem">
            <div
              class="channel-content margin-right-8px hover-selected"
              @click="setCategoryReadyToDelete(categorySettingModal)"
            >
              <div class="channel-main-content">
                <div class="channel-name-wrapper">
                  <div
                    class="primary-text-content red-color text-align-center font-size-14px"
                  >
                    카테고리 삭제
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </template>
      <template slot="setting-content">
        <form>
          <div class="server-name-input-container">
            <h5 class="label-id black-color">카테고리 이름</h5>
            <div class="friends-state-text">
              <input
                width="100%"
                type="text"
                maxlength="100"
                class="channel-name-input"
              />
            </div>
          </div>
        </form>
      </template>
    </setting-modal>
  </div>
</template>

<script>
import SettingModal from "@/components/common/SettingModal.vue";
import { mapState, mapMutations } from "vuex";
export default {
  components: {
    SettingModal,
  },
  computed: {
    ...mapState("community", ["categorySettingModal"]),
  },
  methods: {
    ...mapMutations("community", [
      "setCategorySettingModal",
      "setCategoryReadyToDelete",
    ]),
  },
};
</script>

<style></style>
