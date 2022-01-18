<template>
  <div class="modal" v-if="false">
    <div class="blurred-background" @click="exitCreate"></div>
    <div class="modal-container">
      <template>
        <modal @exit="exitCreate">
          <template slot="header"> </template>
          <template slot="content">
            <div class="content justify-content-center">
              <div class="profile-banner-preview">
                <div class="banner-background"></div>
                <div class="avatar-uploader">
                  <div class="avatar-uploader-inner">
                    <img
                      class="avatar-uploader-image"
                      :src="userimage ? userimage : discordProfile"
                      alt=" "
                    />
                  </div>
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
                  <div class="profile-divider" />
                  <div class="profile-about-me-section">
                    <div class="justify-content-space-between">
                      <div class="subtext">내 소개</div>
                    </div>
                    <input
                      type="text"
                      class="input-default"
                      placeholder="useraboutme"
                    />
                  </div>
                </div>
              </div>
            </div>
          </template>
          <template slot="footer"> </template>
        </modal>
      </template>
    </div>
  </div>
</template>

<script>
import { mapState } from "vuex";
import { selectProfile } from "../utils/common.js";
export default {
  data() {
    return {
      discordProfile: "",
    };
  },
  computed: {
    ...mapState("auth", ["code", "nickname", "userimage", "useraboutme"]),
  },
  async created() {
    console.log(this.userimage);
    if (!this.userimage) {
      const classify = this.code % 4;
      const result = selectProfile(classify);
      this.discordProfile = require("../assets/" + result + ".png");
    }
  },
};
</script>

<style></style>
