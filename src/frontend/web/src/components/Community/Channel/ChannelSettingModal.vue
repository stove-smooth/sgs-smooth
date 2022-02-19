<template>
  <div class="modal" v-if="channelSettingModal">
    <div
      class="blurred-background"
      @click="setChannelSettingModal(false)"
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
                    채널 편집
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="primary-seperator"></div>
          <div class="channel-content-wrapper" role="listitem">
            <div
              class="channel-content margin-right-8px hover-selected"
              @click="setChannelReadyToDelete(channelSettingModal)"
            >
              <div class="channel-main-content">
                <div class="channel-name-wrapper">
                  <div
                    class="primary-text-content red-color text-align-center font-size-14px"
                  >
                    채널 삭제
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
            <div class="justify-content-space-between">
              <h5 class="label-id black-color">채널 이름</h5>
              <button class="small-button">수정</button>
            </div>
            <div class="friends-state-text">
              <input
                width="100%"
                type="text"
                maxlength="100"
                class="channel-name-input"
                v-model="channelSettingModal.name"
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
    ...mapState("community", ["channelSettingModal"]),
  },
  methods: {
    ...mapMutations("community", [
      "setChannelSettingModal",
      "setChannelReadyToDelete",
    ]),
  },
};
</script>

<style>
.hover-selected:hover {
  background-color: rgba(79, 84, 92, 0.32);
}
</style>
