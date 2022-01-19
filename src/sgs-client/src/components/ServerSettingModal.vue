<template>
  <div class="modal" v-if="false">
    <div class="blurred-background"></div>
    <setting-modal>
      <template slot="setting-sidebar">
        <div class="channel-default-container">
          <h2 class="small-title-text text-align-center">서버 이름</h2>
          <div class="channel-content-wrapper" role="listitem">
            <div class="channel-content margin-right-8px">
              <div class="channel-main-content">
                <div class="channel-name-wrapper">
                  <div
                    class="primary-text-content white-color text-align-center font-size-14px"
                  >
                    일반
                  </div>
                </div>
              </div>
            </div>
          </div>
          <h2 class="small-title-text text-align-center">사용자 관리</h2>
          <div class="channel-content-wrapper" role="listitem">
            <div class="channel-content margin-right-8px">
              <div class="channel-main-content">
                <div class="channel-name-wrapper">
                  <div
                    class="primary-text-content white-color text-align-center font-size-14px"
                  >
                    멤버
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="channel-content-wrapper" role="listitem">
            <div class="channel-content margin-right-8px">
              <div class="channel-main-content">
                <div class="channel-name-wrapper">
                  <div
                    class="primary-text-content white-color text-align-center font-size-14px"
                  >
                    초대
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="channel-content-wrapper" role="listitem">
            <div class="channel-content margin-right-8px">
              <div class="channel-main-content">
                <div class="channel-name-wrapper">
                  <div
                    class="primary-text-content white-color text-align-center font-size-14px"
                  >
                    차단
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </template>
      <template slot="setting-content"></template>
    </setting-modal>
  </div>
</template>

<script>
import SettingModal from "./common/SettingModal.vue";
export default {
  components: {
    SettingModal,
  },
};
</script>

<style></style>
