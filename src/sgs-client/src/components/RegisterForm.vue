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
                <div class="content">
                  <h5 class="label-id">이메일</h5>
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
                </div>
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
                <div class="content">
                  <h5 class="label-id">비밀번호</h5>
                  <div class="input-wrapper">
                    <input
                      class="input-default"
                      type="text"
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
                <div class="content">
                  <h5 class="label-id">생년월일</h5>
                  <div class="input-container">
                    <div tabindex="1">
                      <div class="input-year">
                        <div class="inputbox">
                          <div class="input-div">
                            <input
                              class="input-css"
                              type="text"
                              autocomplete="off"
                              spellcheck="false"
                              tabindex="0"
                              aria-autocomplete="list"
                              aria-label="년"
                              list="year"
                              placeholder="선택하기"
                              v-model="year"
                            />
                            <datalist id="year" class="scroll">
                              <option
                                :key="year"
                                v-for="year in yearList"
                                class="yearlist"
                              >
                                {{ year }}
                              </option>
                            </datalist>
                          </div>
                          <div class="arrow-div">
                            <div class="arrow-padding">
                              <img src="../assets/down-arrow.svg" />
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div tabindex="2">
                      <div class="input-year">
                        <div class="inputbox">
                          <div class="input-div">
                            <input
                              class="input-css"
                              type="text"
                              autocomplete="off"
                              spellcheck="false"
                              tabindex="0"
                              aria-autocomplete="list"
                              aria-label="월"
                              list="month"
                              placeholder="선택하기"
                              v-model="month"
                            />
                            <datalist id="month" class="scroll">
                              <option
                                :key="month"
                                v-for="month in monthList"
                                class="yearlist"
                              >
                                {{ month }}
                              </option>
                            </datalist>
                          </div>
                          <div class="arrow-div">
                            <div class="arrow-padding">
                              <img src="../assets/down-arrow.svg" />
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div tabindex="3">
                      <div class="input-year">
                        <div class="inputbox">
                          <div class="input-div">
                            <input
                              class="input-css"
                              type="text"
                              autocomplete="off"
                              spellcheck="false"
                              tabindex="0"
                              aria-autocomplete="list"
                              aria-label="일"
                              list="day"
                              placeholder="선택하기"
                              v-model="day"
                            />
                            <datalist id="day" class="scroll">
                              <option
                                :key="day"
                                v-for="day in dayList"
                                class="yearlist"
                              >
                                {{ day }}
                              </option>
                            </datalist>
                          </div>
                          <div class="arrow-div">
                            <div class="arrow-padding">
                              <img src="../assets/down-arrow.svg" />
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <button class="large-button" type="submit">
                  <div class="contents">계속하기</div>
                </button>
                <div class="need-account-button">
                  <button class="small-register-link">
                    <div class="highlight-text contents">
                      이미 계정이 있으신가요?
                    </div>
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
export default {
  data() {
    return {
      id: "",
      username: "",
      pwd: "",
      year: "",
      month: "",
      day: "",
    };
  },
  computed: {
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
  methods: {
    async submitForm() {
      console.log("submit");
    },
  },
};
</script>
<style scoped>
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
  font-family: Whitney, "Apple SD Gothic Neo", NanumBarunGothic, "맑은 고딕",
    "Malgun Gothic", Gulim, 굴림, Dotum, 돋움, "Helvetica Neue", Helvetica,
    Arial, sans-serif;
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
</style>

