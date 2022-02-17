<template>
  <div class="wrapper">
    <div class="characterBackground">
      <div class="wrapper-react">
        <div>
          <div class="authbox authboxmobile themdark">
            <div class="center-wrapper">
              <form @submit.prevent="submitForm" class="auth-container layer">
                <div class="header">
                  <h3 class="title-welcome">돌아오신 걸 환영해요!</h3>
                  <div class="large-description">
                    다시 만나다니 너무 반가워요!
                  </div>
                </div>
                <div class="content">
                  <h5 class="label-id">이메일 또는 전화번호</h5>
                  <div class="input-wrapper">
                    <input
                      class="input-default"
                      type="text"
                      name="id"
                      placeholder
                      aria-label="이메일 또는 전화번호"
                      autocomplete="off"
                      maxlength="999"
                      v-model="id"
                    />
                  </div>
                </div>
                <p class="warning" v-show="!isIdValid && id">
                  이메일 주소에 @를 포함해주세요.
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
                <button class="find-pwd">
                  <div class="highlight-text contents">
                    비밀번호를 잊으셨나요?
                  </div>
                </button>
                <button
                  class="large-button"
                  type="submit"
                  :disabled="!ispwdValid || !isIdValid"
                >
                  <div class="contents">로그인</div>
                </button>
                <p class="red-color">{{ logMessage }}</p>
                <div class="need-account-button">
                  <span class="need-account"> 계정이 필요한가요? </span>
                  <button class="small-register-link">
                    <router-link to="/register" class="highlight-text contents">
                      가입하기
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
import { getToken } from "@/utils/firebase";
import { mapActions, mapMutations, mapState } from "vuex";
import { validateEmail } from "../utils/validation.js";
import { joinCommunity } from "../api/index.js";
export default {
  data() {
    return {
      id: "",
      pwd: "",
      logMessage: "",
    };
  },
  props: {
    path: {
      type: String,
      default: "",
    },
    communityId: {
      type: String,
      default: "",
    },
  },
  computed: {
    ...mapState("utils", ["webPushToken"]),
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
  },
  methods: {
    ...mapActions("user", ["LOGIN"]),
    ...mapMutations("utils", ["setWebPushToken"]),
    async submitForm() {
      try {
        let fcmToken = await getToken();
        console.log("token", fcmToken);
        const userData = {
          email: this.id,
          password: this.pwd,
          type: "web",
          deviceToken: fcmToken,
        };
        await this.LOGIN(userData);
        //만약 초대링크로 들어온 경우면, community로 이동시켜줌.
        if (this.path != "" && this.communityId != "") {
          //커뮤니티 초대링크라면 커뮤니티로 이동시킨다.
          if (this.path == "c") {
            const communityHashCode = {
              code: this.communityId,
            };
            const result = await joinCommunity(communityHashCode);
            this.$router.replace("/channels/" + result.data.result.id);
          }
        } else {
          this.$router.push("/channels/@me");
        }
      } catch (err) {
        console.log("로그인 실패에러", err.response);
        this.logMessage = "로그인에 실패하셨습니다.";
      }
    },
  },
};
</script>

<style>
.wrapper {
  position: relative;
  -webkit-box-flex: 1;
  flex: 1 1 auto;
  z-index: auto;
  overflow: hidden;
}
.characterBackground {
  position: relative;
  width: 100vw;
  height: 100vh;
  overflow: hidden;
  background-image: url("../assets/welcome-img.png");
}
.wrapper-react {
  width: 100%;
  height: 100%;
}
@media (min-width: 486px) {
  .wrapper-react {
    position: absolute;
    top: 0;
    left: 0;
    min-height: 580px;
    align-items: center;
    justify-content: center;
    display: flex;
  }
}

@media (max-width: 830px) {
  .authboxmobile {
    max-width: 480px;
  }
}
@media (max-width: 485px) {
  .authboxmobile {
    max-width: unset;
  }
}

.authboxmobile {
  width: 784px;
}

.authbox {
  width: 480px;
  padding: 32px;
  font-size: 18px;
  -webkit-box-shadow: 0 2px 10px 0 rgb(0 0 0 / 20%);
  box-shadow: 0 2px 10px 0 rgb(0 0 0 / 20%);
  border-radius: 5px;
  -webkit-box-sizing: border-box;
  box-sizing: border-box;
}

@media (max-width: 485px) {
  .authbox {
    position: absolute;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    padding: 70px 16px 40px;
    width: 100%;
    height: 100%;
    min-height: 500px;
    display: -webkit-box;
    display: -ms-flexbox;
    display: flex;
    -webkit-box-pack: center;
    -ms-flex-pack: center;
    justify-content: center;
    -webkit-box-align: center;
    -ms-flex-align: center;
    align-items: center;
    background: -webkit-gradient(
      linear,
      right top,
      left bottom,
      from(#3d4046),
      to(#1e1e23)
    );
    background: linear-gradient(to left bottom, #3d4046, #1e1e23);
    border-radius: 0;
    overflow: scroll;
  }
}

.themdark {
  color: #72767d;
  background-color: #36393f;
}
.center-wrapper {
  width: 100%;
  text-align: center;
}

.layer {
  display: flex;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  flex-direction: column;
  overflow: hidden;
  -webkit-box-flex: 1;
  flex: 1 1 auto;
  flex-grow: 1;
}
.auth-container {
  min-width: 0;
  min-height: 0;
  -webkit-box-align: start;
  -ms-flex-align: start;
  align-items: flex-start;
}

.header {
  display: -webkit-box;
  display: -ms-flexbox;
  display: flex;
  -webkit-box-align: center;
  -ms-flex-align: center;
  align-items: center;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  -ms-flex-direction: column;
  flex-direction: column;
  width: 100%;
}
.title-welcome {
  font-weight: 600;
  font-size: 24px;
  line-height: 30px;
  margin-bottom: 8px;
  color: var(--white-color);
}
.large-description {
  font-size: 16px;
  line-height: 20px;
  font-weight: 600;
}
.content {
  width: 100%;
  text-align: left;
  margin-top: 6px;
}

.label-id {
  color: var(--description-primary);
  margin-bottom: 8px;
  font-size: 12px;
  line-height: 16px;
}
.input-wrapper {
  -webkit-box-flex: 1;
  -ms-flex-positive: 1;
  flex-grow: 1;
  display: -webkit-box;
  display: -ms-flexbox;
  display: flex;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  -ms-flex-direction: column;
  flex-direction: column;
}

.input-default {
  border: none;
  background-color: transparent;
  padding: 10px;
  height: 40px;
  font-size: 16px;
  -webkit-box-sizing: border-box;
  box-sizing: border-box;
  width: 100%;
  border-radius: 3px;
  background-color: #3b3b3b;
  border: 1px solid black;
  -webkit-transition: border-color 0.2s ease-in-out;
  transition: border-color 0.2s ease-in-out;
  color: #dcddde;
}

.find-pwd {
  margin-top: 4px;
  line-height: 16px;
  background-color: #36393f;
  border: none;
}

.large-button {
  color: var(--white-color);
  font-size: 16px;
  line-height: 24px;
  margin-bottom: 8px;
  width: 130px;
  height: 44px;
  min-width: 130px;
  min-height: 44px;
  width: 100%;
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
  background: none;
  border: none;
  border-radius: 5px;
  font-size: 14px;
  font-weight: 500;
  line-height: 16px;
  padding: 2px 16px;
  background-color: var(--discord-primary);
  margin-top: 20px;
  cursor: pointer;
}
.large-button:disabled {
  cursor: default;
  opacity: 0.5;
}

.need-account-button {
  margin-top: 4px;
  font-weight: 500;
}
.need-account {
  font-size: 14px;
  line-height: 16px;
}
.small-register-link {
  display: inline-block;
  margin-left: 4px;
  margin-bottom: 0;
  vertical-align: bottom;
  padding: 0;
  background-color: #36393f;
  border: none;
}
body,
html {
  margin: 0;
  padding: 0;
}
</style>
