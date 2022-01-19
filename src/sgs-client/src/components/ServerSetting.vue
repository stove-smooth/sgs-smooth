<template>
  <div class="modal" v-if="categorySettingModal">
    <div
      class="blurred-background"
      @click="setCategorySettingModal(false)"
    ></div>
    <setting-modal>
      <template slot="setting-sidebar">
        <div
          class="channel-default-container"
          data-dnd-name="일반"
          aria-label="채널"
        >
          <div class="channel-content-wrapper" role="listitem">
            <div class="channel-content" v-bind:style="{ marginRight: '8px' }">
              <div class="channel-main-content">
                <div class="channel-name-wrapper">
                  <div
                    class="primary-text-content white-color text-align-center"
                  >
                    카테고리 편집
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="channel-content-wrapper" role="listitem">
            <div class="channel-content" v-bind:style="{ marginRight: '8px' }">
              <div class="channel-main-content">
                <div class="channel-name-wrapper">
                  <div class="primary-text-content red-color text-align-center">
                    카테고리 삭제
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </template>
      <template slot="setting-content">
        <div class="setting-content-container">
          <div class="primary-text-content white-color margin-bottom-16px">
            일반
          </div>
          <h2 class="small-title-text">카테고리 이름</h2>
          <div class="input-wrapper">
            <input class="input-default" />
          </div>
        </div>
      </template>
    </setting-modal>
  </div>
</template>

<script>
import SettingModal from "../components/common/SettingModal.vue";
import { mapState, mapMutations } from "vuex";
export default {
  components: {
    SettingModal,
  },
  computed: {
    ...mapState("server", ["categorySettingModal"]),
  },
  methods: {
    ...mapMutations("server", ["setCategorySettingModal"]),
  },
};
</script>

<style></style>
