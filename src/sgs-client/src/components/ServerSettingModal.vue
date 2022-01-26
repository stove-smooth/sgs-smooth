<template>
  <div class="modal" v-if="serverSettingModal">
    <div class="blurred-background" @click="setServerSettingModal(null)"></div>
    <setting-modal>
      <template slot="setting-sidebar">
        <div class="channel-default-container">
          <h2 class="small-title-text text-align-center">서버 이름</h2>
          <div class="channel-content-wrapper" role="listitem">
            <div
              class="channel-content margin-right-8px"
              @mouseover="hover('일반')"
              v-bind:class="{
                'channel-content-hover': hovered === '일반',
              }"
            >
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
            <div
              class="channel-content margin-right-8px"
              @mouseover="hover('멤버')"
              v-bind:class="{
                'channel-content-hover': hovered === '멤버',
              }"
            >
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
            <div
              class="channel-content margin-right-8px"
              @mouseover="hover('초대')"
              v-bind:class="{
                'channel-content-hover': hovered === '초대',
              }"
            >
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
            <div
              class="channel-content margin-right-8px"
              @mouseover="hover('차단')"
              v-bind:class="{
                'channel-content-hover': hovered === '차단',
              }"
            >
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
          <template v-if="communityOwner">
            <div class="primary-seperator"></div>
            <div class="channel-content-wrapper" role="listitem">
              <div
                class="channel-content margin-right-8px"
                @click="setCommunityReadyToDelete(serverSettingModal)"
                @mouseover="hover('서버 삭제')"
                v-bind:class="{
                  'channel-content-hover': hovered === '서버 삭제',
                }"
              >
                <div class="channel-main-content">
                  <div class="channel-name-wrapper">
                    <div
                      class="primary-text-content red-color text-align-center font-size-14px"
                    >
                      서버 삭제
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </template>
        </div>
      </template>
      <template slot="setting-content"></template>
    </setting-modal>
  </div>
</template>

<script>
import { mapState, mapMutations } from "vuex";
import SettingModal from "./common/SettingModal.vue";
export default {
  components: {
    SettingModal,
  },
  data() {
    return {
      hovered: "",
    };
  },
  computed: {
    ...mapState("server", ["serverSettingModal", "communityOwner"]),
  },
  methods: {
    ...mapMutations("server", [
      "setServerSettingModal",
      "setCommunityReadyToDelete",
    ]),
    hover(index) {
      this.hovered = index;
    },
  },
};
</script>

<style></style>
