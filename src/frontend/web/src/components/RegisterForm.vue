<template>
  <div class="wrapper">
    <div class="characterBackground">
      <div class="wrapper-react">
        <div>
          <div class="authbox authboxmobile themdark">
            <div class="center-wrapper">
              <form @submit.prevent="submitForm" class="auth-container layer">
                <div class="header">
                  <h3 class="title-welcome">계정 만들기</h3>
                </div>
                <template v-if="checked">
                  <div class="input-wrapper">
                    <div class="input-default">
                      {{ id }}
                    </div>
                  </div>
                </template>
                <template v-else>
                  <form class="content" @submit.prevent="verifyEmail">
                    <div class="verify-email-wrapper">
                      <h5 class="label-id">이메일</h5>
                      <button
                        class="small-button"
                        :disabled="!isIdValid"
                        type="submit"
                      >
                        전송
                      </button>
                    </div>
                    <div class="input-wrapper">
                      <input
                        class="input-default"
                        type="text"
                        name="id"
                        placeholder
                        aria-label="이메일"
                        autocomplete="off"
                        maxlength="999"
                        v-model="id"
                      />
                    </div>
                  </form>
                  <p class="warning" v-show="!isIdValid && id">
                    이메일 주소에 @를 포함해주세요.
                  </p>
                  <p class="warning" v-show="isIdValid && !emailsend">
                    전송 버튼을 눌러 이메일을 인증해주세요.
                  </p>
                  <form class="content" @submit.prevent="verifyAuthCode">
                    <div class="verify-email-wrapper">
                      <h5 class="label-id">인증코드</h5>
                      <button
                        class="small-button"
                        :disabled="!authcode"
                        type="submit"
                      >
                        확인
                      </button>
                    </div>
                    <div class="input-wrapper">
                      <input
                        class="input-default"
                        type="text"
                        name="authcode"
                        placeholder
                        aria-label="인증코드"
                        autocomplete="off"
                        maxlength="999"
                        v-model="authcode"
                      />
                    </div>
                  </form>
                  <p class="warning" v-show="emailsend && !authcode">
                    이메일을 통해 전해 받은 인증코드 6자리를 입력해주세요.
                  </p>
                  <p class="warning" v-show="authlogmessage">
                    {{ authlogmessage }}
                  </p>
                </template>
                <div class="content">
                  <h5 class="label-id">사용자명</h5>
                  <div class="input-wrapper">
                    <input
                      class="input-default"
                      type="text"
                      name="username"
                      placeholder
                      aria-label="사용자명"
                      autocomplete="off"
                      maxlength="999"
                      v-model="username"
                    />
                  </div>
                </div>
                <p class="warning" v-show="!isnameValid && username">
                  사용자명은 2글자 이상 20자 이상으로 해주세요.
                </p>
                <div class="content">
                  <h5 class="label-id">비밀번호</h5>
                  <div class="input-wrapper">
                    <input
                      class="input-default"
                      type="password"
                      name="pwd"
                      placeholder
                      aria-label="비밀번호"
                      autocomplete="off"
                      maxlength="999"
                      spellcheck="false"
                      v-model="pwd"
                    />
                  </div>
                </div>
                <p class="warning" v-show="pwd && !ispwdValid">
                  8자 이상 15자 이하 비밀번호를 입력해주세요.
                </p>
                <button
                  :disabled="!isnameValid || !ispwdValid || !checked"
                  class="large-button"
                  type="submit"
                >
                  <div class="contents">계속하기</div>
                </button>
                <div class="need-account-button">
                  <button class="small-register-link">
                    <router-link
                      to="/login"
                      div
                      class="highlight-text contents"
                    >
                      이미 계정이 있으신가요?
                    </router-link>
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions } from "vuex";
import { registerUser, sendAuthCode, verifyAuthCode } from "../api/index.js";
import { getToken } from "@/utils/firebase";
import { validateEmail, validateName } from "../utils/validation.js";
export default {
  data() {
    return {
      id: "",
      username: "",
      pwd: "",
      year: "",
      month: "",
      day: "",
      authcode: "",
      emailsend: false,
      checked: false,
      authlogmessage: "",
    };
  },
  computed: {
    isnameValid() {
      return validateName(this.username);
    },
    ispwdValid() {
      if (this.pwd.length >= 8 && this.pwd.length <= 15) {
        return true;
      } else {
        return false;
      }
    },
    isIdValid() {
      return validateEmail(this.id);
    },
    yearList() {
      var list = [];
      for (let i = 1920; i <= 2020; i++) list.push(i);
      return list;
    },
    monthList() {
      var list = [];
      for (let i = 1; i <= 12; i++) list.push(i + "월");
      return list;
    },
    dayList() {
      var list = [];
      for (let i = 1; i <= 31; i++) list.push(i);
      return list;
    },
  },
  watch: {
    emailsend(newVal, oldVal) {
      if (newVal != oldVal) {
        if (newVal == true) {
          alert("인증번호가 발송되었습니다.");
        }
      }
    },
  },
  methods: {
    ...mapActions("user", ["LOGIN"]),
    async submitForm() {
      const userData = {
        email: this.id,
        password: this.pwd,
        name: this.username,
      };
      await registerUser(userData);
      let fcmToken = await getToken();

      const userInfo = {
        email: this.id,
        password: this.pwd,
        type: "web",
        deviceToken: fcmToken,
      };
      await this.LOGIN(userInfo);
      this.$router.push("/channels/@me");
    },
    async verifyEmail() {
      this.emailsend = false;
      const userData = {
        email: this.id,
      };
      let result;
      try {
        result = await sendAuthCode(userData);
      } catch (err) {
        console.log(err.response);
      }
      if (result.data.code === 1000) {
        this.emailsend = true;
      }
    },
    async verifyAuthCode() {
      this.authlogmessage = "";
      try {
        const result = await verifyAuthCode(this.authcode);
        if (result.data.code === 1000) {
          this.checked = true;
        }
      } catch (err) {
        this.authlogmessage = "유효하지 않은 인증번호입니다";
      }
    },
  },
};
</script>
<style>
.verify-email-wrapper {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
}
.small-button {
  font-weight: 400;
  font-size: 11px;
  background-color: var(--discord-primary);
  border-radius: 5px;
  cursor: pointer;
  color: white;
  height: 16px;
  align-self: flex-end;
  margin-bottom: 12px;
}
.small-button:disabled {
  cursor: default;
  opacity: 0.5;
}
.input-container {
  width: 100%;
  display: flex;
  -webkit-box-pack: justify;
  justify-content: space-between;
  margin-bottom: 4px;
}
.input-year {
  width: 120px;
  position: relative;
  box-sizing: border-box;
}
.inputbox {
  -webkit-box-align: center;
  align-items: center;
  background-color: rgba(0, 0, 0, 0.1);
  border-color: rgba(32, 34, 37, 0.5);
  border-radius: 4px;
  border-style: solid;
  border-width: 1px;
  display: flex;
  flex-wrap: wrap;
  -webkit-box-pack: justify;
  justify-content: space-between;
  min-height: 40px;
  position: relative;
  transition: border 0.15s ease 0s;
  box-sizing: border-box;
  outline: 0px !important;
}
.input-div {
  -webkit-box-align: center;
  align-items: center;
  display: flex;
  flex: 1 1 0%;
  flex-wrap: wrap;
  padding: 2px 8px;
  position: relative;
  overflow: hidden;
  box-sizing: border-box;
}
.input-css {
  background-color: rgba(0, 0, 0, 0.1);
  border: none;
  color: rgb(114, 118, 125);
}
.scroll {
  position: absolute;
  top: 0px;
  left: 0px;
  visibility: hidden;
  height: 0px;
  overflow: scroll;
  white-space: pre;
  font-size: 18px;
  font-weight: 400;
  font-style: normal;
  letter-spacing: normal;
  text-transform: none;
}
option {
  background: rgba(0, 0, 0, 0.1);
}
.arrow-div {
  align-items: center;
  align-self: stretch;
  display: flex;
  flex-shrink: 0;
  box-sizing: border-box;
}
.arrow-padding {
  color: rgb(185, 187, 190);
  display: flex;
  padding: 8px 8px 8px 0px;
  transition: color 150ms ease 0s;
  box-sizing: border-box;
  cursor: pointer;
  opacity: 1;
}
.warning {
  color: #ff4057;
  margin: 0;
  font-size: 9px;
}
</style>
