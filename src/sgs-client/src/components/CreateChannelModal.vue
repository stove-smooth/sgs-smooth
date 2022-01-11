<template>
  <div class="modal">
    <div class="bg" @click="closeModal"></div>
    <div class="modalBox">
      <CreateServerForm @exit="closeModal">
        <template slot="header">
          <h3 class="big-title">채팅 채널 만들기</h3>
          <div class="subtitle">: 개인 공간에 속해있음</div>
        </template>
        <template slot="content">
          <h5 class="label-id" v-bind:style="{ color: 'black' }">채널 유형</h5>
          <button class="select-channel-type-button">
            <div v-bind:style="{ width: '24px', padding: '10px' }">
              <svg class="radio_button_checked"></svg>
            </div>
            <svg class="big-hashtag-icon"></svg>
            <div
              class="flex-direction-column"
              v-bind:style="{ paddingLeft: '10px' }"
            >
              <div
                class="action-title"
                v-bind:style="{ alignSelf: 'flex-start' }"
              >
                채팅 채널
              </div>
              <div class="subtitle">
                이미지, 스티커, 의견, 농담을 올려보세요.
              </div>
            </div>
          </button>
          <button class="select-channel-type-button">
            <div v-bind:style="{ width: '24px', padding: '10px' }">
              <svg class="radio_button_unchecked"></svg>
            </div>
            <svg class="big-voice-channel"></svg>
            <div
              class="flex-direction-column"
              v-bind:style="{ paddingLeft: '10px' }"
            >
              <div
                class="action-title"
                v-bind:style="{ alignSelf: 'flex-start' }"
              >
                음성 채널
              </div>
              <div class="subtitle">
                이미지, 스티커, 의견, 농담을 올려보세요.
              </div>
            </div>
          </button>

          <form>
            <div class="server-name-input-container">
              <h5 class="label-id" v-bind:style="{ color: 'black' }">
                채널 이름
              </h5>
              <div
                class="server-name-input"
                v-bind:style="{ display: 'flex', flexDirection: 'row' }"
              >
                <svg class="voice-channel"></svg>
                <input
                  width="100%"
                  type="text"
                  placeholder="channelName"
                  maxlength="100"
                  v-model="channelName"
                />
              </div>
            </div>
          </form>
        </template>
        <template slot="footer">
          <div class="create-server-form-footer">
            <h3 class="footer-title">이미 초대장을 받으셨나요?</h3>
            <button class="grey-large-button" type="button">
              <div>서버 참가하기</div>
            </button>
          </div>
        </template>
      </CreateServerForm>
    </div>
  </div>
</template>

<script>
import CreateServerForm from "../components/common/CreateServerForm.vue";
export default {
  components: {
    CreateServerForm,
  },
  data() {
    return {
      channelName: "새로운 채널",
    };
  },
  methods: {
    closeModal() {
      this.$emit("exit-create-channel");
    },
  },
};
</script>

<style scoped>
.modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  display: flex;
  background: none !important;
  z-index: 1002;
  justify-content: center;
  align-items: center;
}

.modal .bg {
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.6);
}

.modalBox {
  position: absolute;
  background-color: var(--white-color);
  width: 440px;
  max-height: 720px;
  min-height: 200px;
  border-radius: 4px;
}

.radio_button_checked {
  display: flex;
  width: 24px;
  height: 24px;
  background-image: url("../assets/radio_button_checked.svg");
}
.radio_button_unchecked {
  width: 20px;
  height: 20px;
  background-image: url("../assets/radio_button_unchecked.svg");
}
.select-channel-type-button {
  border-radius: 8px;
  border: 1px solid rgba(6, 6, 7, 0.08);
  background-color: var(--white-color);
  margin-bottom: 8px;
  display: flex;
  -webkit-box-align: center;
  align-items: center;
  cursor: pointer;
  width: 100%;
  padding: 10px;
}
.big-hashtag-icon {
  display: flex;
  width: 24px;
  height: 24px;
  background-image: url("../assets/big-hashtag.svg");
}
.big-voice-channel {
  display: flex;
  width: 24px;
  height: 24px;
  background-image: url("../assets/big-voice-channel.svg");
}
</style>
