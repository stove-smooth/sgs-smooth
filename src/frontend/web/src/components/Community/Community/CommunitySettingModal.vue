<template>
  <div class="modal" v-if="communitySettingModal">
    <div
      class="blurred-background"
      @click="setCommunitySettingModal(null)"
    ></div>
    <setting-modal>
      <template slot="setting-sidebar">
        <div class="channel-default-container">
          <h2 class="small-title-text text-align-center">서버 이름</h2>
          <div class="channel-content-wrapper" role="listitem">
            <div
              @click="clickMenu('일반')"
              class="channel-content margin-right-8px"
              @mouseover="hover('일반')"
              @mouseleave="hover('')"
              v-bind:class="{
                'channel-content-hover':
                  hovered === '일반' || menuSelected === '일반',
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
              @click="clickMenu('멤버')"
              class="channel-content margin-right-8px"
              @mouseover="hover('멤버')"
              @mouseleave="hover('')"
              v-bind:class="{
                'channel-content-hover':
                  hovered === '멤버' || menuSelected === '멤버',
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
              @click="clickMenu('초대')"
              @mouseover="hover('초대')"
              @mouseleave="hover('')"
              v-bind:class="{
                'channel-content-hover':
                  hovered === '초대' || menuSelected === '초대',
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
              @click="clickMenu('차단')"
              @mouseover="hover('차단')"
              @mouseleave="hover('')"
              v-bind:class="{
                'channel-content-hover':
                  hovered === '차단' || menuSelected === '차단',
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
                @click="setCommunityReadyToDelete(communitySettingModal)"
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
      <template v-if="menuSelected == '일반'">
        <template slot="setting-content">
          <h1 class="header-title">서버 개요</h1>
          <div class="avatar-uploader-inner">
            <template v-if="isProfileAvatar()">
              <img class="avatar-uploader-image" :src="this.icon" alt=" " />
            </template>
            <template v-else>
              <div
                class="avatar-uploader-image white-color justify-content-center align-items-center"
              >
                {{ communitySettingModal.serverName }}
              </div>
            </template>

            <div class="avatar-uploader-hint" v-show="false">아바타 변경</div>
            <div class="avatar-uploader-icon">
              <svg class="img-uploader-icon"></svg>
            </div>
            <input
              class="file-input"
              type="file"
              ref="image"
              accept="image/*"
              @change="uploadImage()"
            />
          </div>
          <form>
            <div class="server-name-input-container">
              <div class="flex-direction-row">
                <h5 class="label-id black-color">서버 이름</h5>
                <div class="margin-left-8px align-items-center">
                  <div class="small-button">수정</div>
                </div>
              </div>

              <div class="friends-state-text">
                <input
                  width="100%"
                  type="text"
                  maxlength="100"
                  class="channel-name-input"
                  v-model="communitySettingModal.serverName"
                />
              </div>
            </div>
          </form>
        </template>
      </template>
      <template v-if="menuSelected == '멤버'">
        <template slot="setting-content">
          <div>
            <h1 class="header-title">멤버</h1>
            <div class="primary-description margin-bottom-16px">멤버-{}명</div>
            <div class="primary-divider" />
          </div>
          <div class="invite-table-container">
            <div class="invite-table-attribute">
              <div class="display-flex white-color">
                <div class="small-profile-wrapper">
                  <img
                    class="avatar"
                    src="https://cdn.discordapp.com/avatars/291948872408760320/5871cf3e8f8baf59e2f21d89b1640556.webp?size=40"
                    alt="image"
                  />
                </div>
                <div class="display-flex white-color align-items-center">
                  <span class="bold-username">밍디</span>
                  <span class="user-code">#1223</span>
                </div>
              </div>
            </div>
          </div>
        </template>
      </template>
      <template v-if="menuSelected == '초대'">
        <template slot="setting-content">
          <div>
            <h1 class="header-title">초대</h1>
            <div class="primary-description margin-bottom-16px">
              활성화된 모든 초대 링크 목록이에요. 이 중에서 취소할 수 있어요.
            </div>
            <div class="primary-divider" />
            <div class="invite-table-attribute-container">
              <div class="invite-table-attribute">초대자</div>
              <div class="invite-table-attribute">초대 코드</div>
              <div class="invite-table-attribute">취소</div>
            </div>
          </div>
          <div class="invite-table-container">
            <div class="invite-table-attribute">
              <div class="display-flex white-color">
                <div class="small-profile-wrapper">
                  <img
                    class="avatar"
                    src="https://cdn.discordapp.com/avatars/291948872408760320/5871cf3e8f8baf59e2f21d89b1640556.webp?size=40"
                    alt="image"
                  />
                </div>
                <div class="display-flex white-color align-items-center">
                  <span class="bold-username">밍디</span>
                  <span class="user-code">#1223</span>
                </div>
              </div>
            </div>
            <div class="invite-table-attribute">
              <div class="display-flex white-color align-items-center">
                <div>초대 코드</div>
              </div>
            </div>
            <div class="invite-table-attribute">
              <div class="red-color">취소</div>
            </div>
          </div>
        </template>
      </template>
      <template v-if="menuSelected == '차단'">
        <template slot="setting-content">
          <div>
            <h1 class="header-title">차단한 사람</h1>
            <div class="primary-description margin-bottom-16px">
              차단은 자동으로 계정과 IP를 동시에 차단해요. 사용자는 프록시를
              사용하여 IP 차단을 우회할 수 있어요.
            </div>
            <div class="primary-divider" />
          </div>
          <div class="invite-table-container">
            <div class="invite-table-attribute">
              <div class="display-flex white-color">
                <div class="small-profile-wrapper">
                  <img
                    class="avatar"
                    src="https://cdn.discordapp.com/avatars/291948872408760320/5871cf3e8f8baf59e2f21d89b1640556.webp?size=40"
                    alt="image"
                  />
                </div>
                <div class="display-flex white-color align-items-center">
                  <span class="bold-username">밍디</span>
                  <span class="user-code">#1223</span>
                </div>
              </div>
            </div>
            <div class="invite-table-attribute">
              <div class="red-color">취소</div>
            </div>
          </div>
        </template>
      </template>
    </setting-modal>
  </div>
</template>

<script>
import { mapState, mapMutations } from "vuex";
import SettingModal from "@/components/common/SettingModal.vue";
export default {
  components: {
    SettingModal,
  },
  data() {
    return {
      hovered: "",
      menuSelected: "일반",
      icon: null,
    };
  },
  created() {
    console.log(this.$route.params.serverid);
  },
  computed: {
    ...mapState("community", [
      "communitySettingModal",
      "communityOwner",
      "communityList",
    ]),
  },
  methods: {
    ...mapMutations("community", [
      "setCommunitySettingModal",
      "setCommunityReadyToDelete",
    ]),
    hover(index) {
      this.hovered = index;
    },
    clickMenu(menu) {
      this.menuSelected = menu;
    },
    isProfileAvatar() {
      for (var i = 0; i < this.communityList.length; i++) {
        if (this.communityList[i].id == this.$route.params.serverid) {
          if (this.communityList[i].icon == null) {
            return false;
          } else {
            this.icon = this.communityList[i].icon;
            return true;
          }
        }
      }
    },
  },
};
</script>

<style>
.invite-table-attribute-container {
  box-sizing: border-box;
  flex-direction: row;
  flex-wrap: nowrap;
  -webkit-box-pack: start;
  justify-content: flex-start;
  align-items: stretch;
  display: flex;
}
.invite-table-attribute {
  box-sizing: border-box;
  margin-top: 0;
  margin-bottom: 0;
  font-size: 12px;
  line-height: 16px;
  font-weight: 600;
  text-transform: uppercase;
  color: #b9bbbe;
  flex: 3 1 0px;
  align-items: center;
  display: flex;
}
.invite-table-container {
  flex: 1 1 auto;
  height: 36px;
  position: relative;
  font-size: 16px;
  line-height: 20px;
  color: #dcddde;
  flex-direction: row;
  flex-wrap: nowrap;
  justify-content: flex-start;
  align-items: stretch;
  display: flex;
}
</style>
