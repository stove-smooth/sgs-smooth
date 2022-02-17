<template>
  <div class="modal" v-if="friendsProfileModal">
    <div class="blurred-background" @click="exitProfileModal"></div>
    <div class="profile-modal-container">
      <template>
        <div class="content justify-content-center">
          <div class="profile-banner-preview">
            <div class="banner-background"></div>
            <div class="avatar-uploader">
              <div class="avatar-uploader-inner">
                <img
                  class="avatar-uploader-image"
                  :src="profileImage"
                  alt=" "
                />
              </div>
            </div>
            <div class="profile-name-header">
              <div class="justify-content-space-between">
                <div class="profile-header-nametag">
                  <div class="bold-username">
                    {{ profileUser }}
                  </div>
                  <div class="user-code">#{{ friendsProfileModal.code }}</div>
                </div>
              </div>
            </div>
            <!-- <div class="profile-info">
              <div class="primary-divider" />
              <div class="margin-bottom-16px">
                <div class="justify-content-space-between">
                  <div class="subtext white-color">내 소개</div>
                </div>
              </div>
            </div> -->
          </div>
        </div>
      </template>
    </div>
  </div>
</template>

<script>
import { mapState, mapMutations } from "vuex";
export default {
  computed: {
    ...mapState("friends", ["friendsProfileModal"]),
    profileImage() {
      if (this.friendsProfileModal.profileImage) {
        return this.friendsProfileModal.profileImage;
      } else {
        return this.friendsProfileModal.image;
      }
    },
    profileUser() {
      if (this.friendsProfileModal.username) {
        return this.friendsProfileModal.username;
      } else {
        return this.friendsProfileModal.nickname;
      }
    },
  },
  methods: {
    ...mapMutations("friends", ["setFriendsProfileModal"]),
    exitProfileModal() {
      this.setFriendsProfileModal(null);
    },
  },
};
</script>

<style>
.profile-modal-container {
  position: absolute;
  max-height: 720px;
  min-height: 200px;
  border-radius: 4px;
}
</style>
