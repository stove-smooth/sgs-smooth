<template>
  <div class="friends-state-list-container">
    <header class="friends-new-add-header">
      <h2 class="large-description" v-bind:style="{ color: '#fff' }">
        친구 추가하기
      </h2>
      <form autocomplete="off" @submit.prevent="addNewFriends">
        <div class="white-color">
          Discord Tag를 사용하여 친구를 추가할 수 있어요. 대문자, 소문자를
          구별한답니다!
        </div>
        <div
          class="add-friends-input-wrapper"
          v-bind:class="{
            'positive-border-color': isAddedSuccess === 'success',
          }"
        >
          <input
            class="add-friends-input-text"
            maxlength="37"
            placeholder="사용자명#0000"
            aria-label="사용자명#0000 입력"
            v-model="userinfo"
          />
          <button
            type="submit"
            class="middle-button"
            :disabled="!isUserInfoValid"
          >
            친구 요청보내기
          </button>
        </div>
        <div
          v-if="isAddedSuccess === 'success'"
          class="large-description"
          v-bind:style="{ color: '#58f287' }"
        >
          <strong>{{ this.username }}</strong
          >에게 성공적으로 친구 요청을 보냈어요.
        </div>
        <div
          v-if="isAddedSuccess === 'fail'"
          class="large-description red-color"
        >
          친구 추가에 실패하였습니다.
        </div>
      </form>
    </header>
    <div class="wrapper">
      <div class="friends-empty-container">
        <div class="friends-empty-image-wrapper">
          <div class="friends-empty-image"></div>
          <div class="large-description">친구를 기다리고 있어요</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { friendRequest } from "../api/index.js";
export default {
  data() {
    return {
      isAdded: true,
      userinfo: "",
      username: "",
      usercode: "",
      isAddedSuccess: "",
    };
  },
  computed: {
    isUserInfoValid() {
      var user = this.userinfo.split("#");
      if (user[1]) {
        return true;
      } else {
        return false;
      }
    },
  },
  methods: {
    async addNewFriends() {
      try {
        var user = this.userinfo.split("#");
        this.username = user[0];
        this.usercode = user[1];
        console.log(this.username, this.usercode);
        const userData = {
          name: this.username,
          code: this.usercode,
        };
        const result = await friendRequest(userData);
        if (result.data.isSuccess) {
          this.isAddedSuccess = "success";
        }
      } catch (err) {
        this.isAddedSuccess = "fail";
        console.log(err);
        console.log("실패");
      }
    },
  },
};
</script>

<style>
.friends-new-add-header {
  flex-shrink: 0;
  border-bottom: 1px solid hsla(0, 0%, 100%, 0.06);
  padding: 20px 30px;
}
.add-friends-input-wrapper {
  -webkit-box-align: center;
  align-items: center;
  background-color: rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(0, 0, 0, 0.3);
  border-radius: 8px;
  display: flex;
  margin-top: 16px;
  padding: 0 16px;
  position: relative;
}
.add-friends-input-text {
  font-size: 16px;
  font-weight: 500;
  letter-spacing: 0.04em;
  line-height: 20px;
  white-space: pre;
  background-color: #36393f;
  border: none;
  box-sizing: border-box;
  color: #dcddde;
  -webkit-box-flex: 1;
  flex: 1 1 auto;
  margin-right: 16px;
  padding: 16px 0;
  z-index: 1;
}
.friends-empty-container {
  position: absolute;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  -webkit-box-pack: center;
  justify-content: center;
  -webkit-box-align: center;
  align-items: center;
}
.friends-empty-image-wrapper {
  width: 100%;
  height: 100%;
  max-width: 440px;
  margin-left: auto;
  margin-right: auto;
  flex-direction: column;
  flex-wrap: nowrap;
  justify-content: center;
  align-items: center;
  display: flex;
}
.friends-empty-image {
  flex: 0 1 auto;
  width: 376px;
  height: 162px;
  background-size: 100% 100%;
  margin-bottom: 40px;
  background-image: url("../assets/empty-friends-background.svg");
}
.positive-border-color {
  border-color: #58f287;
}
.middle-button:disabled {
  cursor: default;
  opacity: 0.5;
}
</style>
