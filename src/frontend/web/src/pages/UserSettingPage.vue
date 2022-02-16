<template>
  <div class="wrapper">
    <div class="settings-background">
      <div class="wrapper-react">
        <div>
          <div class="center-wrapper">
            <div>
              <div class="header">
                <svg class="close" @click="closeSettings"></svg>
              </div>
              <div class="content"></div>
              <div class="content justify-content-center">
                <div class="profile-banner-preview">
                  <div class="banner-background"></div>
                  <div class="avatar-uploader">
                    <div class="avatar-uploader-inner">
                      <img
                        class="avatar-uploader-image"
                        :src="userimage"
                        alt=" "
                      />
                      <div class="avatar-uploader-hint" v-show="false">
                        아바타 변경
                      </div>
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
                    <button class="small-button" @click="resetImage">
                      기본 프로필 사용
                    </button>
                    <button
                      class="small-button"
                      v-bind:style="{ marginLeft: '12px' }"
                      @click="changeProfile"
                    >
                      프로필 저장
                    </button>
                  </div>
                  <div class="profile-name-header">
                    <div class="justify-content-space-between">
                      <div class="profile-header-nametag">
                        <div class="bold-username">{{ nickname }}</div>
                        <div class="user-code">#{{ code }}</div>
                      </div>
                    </div>
                  </div>
                  <div class="profile-info">
                    <!-- <div class="primary-divider" />
                    <div class="margin-bottom-16px">
                      <div class="justify-content-space-between">
                        <div class="subtext white-color">내 소개</div>
                        <button class="small-button">수정</button>
                      </div>
                      <input
                        type="text"
                        class="input-default"
                        placeholder="useraboutme"
                        v-model="useraboutme"
                      />
                    </div> -->
                  </div>
                  <div class="justify-content-center">
                    <button class="grey-large-button">
                      <a href="javascript:;" @click="logoutUser">로그아웃</a>
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapActions, mapMutations } from "vuex";
import {
  selectProfile,
  converToThumbnail,
  dataUrlToFile,
} from "../utils/common.js";
import { changeUserImage } from "../api/index.js";
export default {
  computed: {
    ...mapState("user", ["code", "nickname", "userimage", "useraboutme"]),
    ...mapState("utils", ["stompSocketClient"]),
  },
  async created() {
    await this.fetchUserInfo();
  },
  methods: {
    ...mapActions("user", ["LOGOUT", "FETCH_USERINFO"]),
    ...mapMutations("user", ["setUserImage"]),
    closeSettings() {
      this.$router.go(-1);
    },
    async fetchUserInfo() {
      await this.FETCH_USERINFO();
    },
    async logoutUser() {
      await this.LOGOUT();
      await this.stompSocketClient.disconnect();
      this.$router.push("/login");
    },
    async uploadImage() {
      let image = this.$refs["image"].files[0];
      const thumbnail = await converToThumbnail(image);
      this.setUserImage(thumbnail);
    },
    async changeProfile() {
      var frm = new FormData();
      const result = await dataUrlToFile(this.userimage);
      frm.append("image", result);
      await changeUserImage(frm);
      window.location.reload();
    },
    resetImage() {
      //프로필을 내릴 시 유저코드에 맞는 기본 프로필을 제공한다.
      const classify = this.code % 4;
      const result = selectProfile(classify);
      console.log("reset", result);
      this.setUserImage(require("../assets/" + result + ".png"));
    },
  },
};
</script>

<style>
.close {
  display: flex;
  background-image: url("../assets/close.svg");
  width: 50px;
  height: 50px;
}
.settings-background {
  position: relative;
  width: 100vw;
  height: 100vh;
  overflow: hidden;
  background-image: url("../assets/setting-background-img.png");
}
.profile-banner-preview {
  position: relative;
  width: 300px;
  min-width: 300px;
  min-height: 200px;
  background-color: #18191c;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.24);
}
.banner-background {
  background-color: rgb(64, 61, 54);
  height: 60px;
  border-radius: 8px 8px 0 0;
  width: 100%;
}
.avatar-uploader {
  top: 16px;
  position: absolute;
  z-index: 1;
  left: 16px;
  text-align: center;
  font-size: 12px;
  box-sizing: border-box;
}
.avatar-uploader-inner {
  width: 80px;
  height: 80px;
  border: 6px solid #18191c;
  background-color: #18191c;
  box-sizing: content-box;
  display: inline-block;
  border-radius: 50%;
  background-size: cover;
  background-position: 50%;
  background-repeat: no-repeat;
  position: relative;
  flex-shrink: 0;
}
.avatar-uploader-image {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background-size: cover;
  background-position: 50%;
  background-repeat: no-repeat;
}
.avatar-uploader-hint {
  font-size: 10px;
  font-weight: 700;
  line-height: 12px;
}
.avatar-uploader-icon {
  position: absolute;
  top: 0;
  right: 0;
  left: auto;
  width: 28px;
  height: 28px;
  background-repeat: no-repeat;
  background-position: 50%;
  border-radius: 50%;
  box-shadow: 0 2px 4px 0 rgb(0 0 0 / 20%);
  display: flex;
  justify-content: center;
  -webkit-box-align: center;
  align-items: center;
  background-color: #dcddde;
}
.img-uploader-icon {
  width: 18px;
  height: 18px;
  background-image: url("../assets/img-uploader-icon.svg");
}
.profile-name-header {
  display: block;
  flex-shrink: 0;
  padding: 64px 16px 16px;
  overflow: hidden;
  position: relative;
  box-sizing: border-box;
}
.profile-header-text {
  display: flex;
  justify-content: space-between;
}
.profile-header-nametag {
  box-sizing: border-box;
  font-size: 20px;
  line-height: 24px;
  word-break: break-word;
  white-space: normal;
  -webkit-box-align: end;
  align-items: flex-end;
  font-weight: 500;
  display: flex;
}

.profile-info {
  padding: 0 16px 16px;
  box-sizing: border-box;
}
</style>
