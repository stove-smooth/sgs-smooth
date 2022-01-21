<template>
  <div class="server-chatting-container">
    <div class="message-container">
      <div class="thin-scrollbar server-chat-scroller">
        <div class="scroller-content">
          <ol class="scroller-inner">
            <div v-for="(item, idx) in receiveList" :key="idx">
              <li class="chat-message-wrapper">
                <div
                  class="primary-chat-message-wrapper others-chat-message-wrapper"
                >
                  <div class="chat-message-content">
                    <img
                      src="https://cdn.discordapp.com/avatars/846330810000605208/e581f53f2ba1f0d06bbcd7b512834a47.webp?size=80"
                      class="chat-avatar clickable"
                      alt="image"
                    />
                    <h2 class="chat-avatar-header">
                      <span class="chat-user-name">{{ item.name }}</span>
                      <span class="chat-time-stamp">{{ item.time }}</span>
                    </h2>
                    <div class="message-content">{{ item.message }}</div>
                  </div>
                </div>
              </li>
            </div>
          </ol>
        </div>
      </div>
    </div>
    <div class="channel-message-input-form">
      <div class="channel-message-area">
        <div class="channel-message-scrollbar-container">
          <div v-if="thumbnails.length > 0">
            <!--ul에 scrollbar추가필요.-->
            <ul
              class="channel-attachment-area scrollbar-ghost"
              role="list"
              data-list-id="attachments"
            >
              <div v-for="(item, index) in thumbnails" :key="index">
                <li
                  class="upload-attachments"
                  role="listitem"
                  data-list-item-id="attachments-upload"
                  tabindex="-1"
                >
                  <div class="message-upload-container">
                    <div class="message-upload-image-container">
                      <div class="spoiler-wrapper">
                        <img
                          class="attach-image"
                          :src="item"
                          alt="첨부이미지"
                        />
                      </div>
                    </div>
                    <div class="message-upload-filename-container">
                      <div class="filename-wrapper">
                        {{ images[index].name }}
                      </div>
                    </div>
                    <div class="message-upload-actionbar-container">
                      <div aria-label="첨부파일 수정" class="actionbar-wrapper">
                        <div class="actionbar-wrapper2">
                          <div
                            @click="deleteAttachment(index)"
                            class="remove-attachment-button"
                            aria-label="첨부 파일 제거"
                            role="button"
                            tabindex="0"
                          >
                            <svg class="trashcan"></svg>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </li>
              </div>
            </ul>
          </div>
          <div class="message-attachment-divider"></div>
          <div class="channel-message-form-inner-button">
            <div class="upload-chat-image-icon">
              <button
                class="message-attach-button"
                aria-label="파일을 업로드하거나 초대를 보내세요"
              >
                <div class="attach-button-inner">
                  <svg class="attach-button"></svg>
                </div>
                <input
                  class="file-input"
                  multiple
                  type="file"
                  ref="images"
                  accept="image/*"
                  @change="uploadImage()"
                />
              </button>
            </div>
            <div class="channel-message-input-area">
              <textarea
                id="input-text-wrapper"
                class="channel-message-input-wrapper"
                aria-haspopup="listbox"
                aria-label="#잡담에서 메시지보내기"
                v-model="text"
                @keyup="sendMessage"
                placeholder="#잡담에 메세지 보내기"
              ></textarea>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { converToThumbnail } from "../utils/common.js";
import { mapState } from "vuex";
export default {
  data() {
    return {
      text: "",
      images: [],
      thumbnails: [],
      receiveList: [],
    };
  },
  computed: {
    ...mapState("user", ["nickname"]),
    ...mapState("utils", ["stompSocketClient", "stompSocketConnected"]),
  },
  watch: {
    stompSocketConnected: function (val) {
      if (val === true) {
        console.log(val);
        this.stompSocketClient.subscribe("/topic/group", (res) => {
          console.log("구독으로 받은 메시지 입니다.", res.body);

          this.receiveList.push(JSON.parse(res.body));
          console.log(this.receiveList);
        });
      } else {
        alert("채팅 연결이 끊겼습니다.");
      }
    },
  },
  methods: {
    sendMessage(e) {
      if (e.keyCode === 13 && !e.shiftKey && this.stompSocketConnected) {
        this.send();
        this.text = "";
      }
    },
    async uploadImage() {
      for (var i = 0; i < this.$refs["images"].files.length; i++) {
        this.images.push(this.$refs["images"].files[i]);
        let thumbnail = await converToThumbnail(this.$refs["images"].files[i]);
        this.thumbnails.push(thumbnail);
      }
    },
    deleteAttachment(index) {
      this.thumbnails.splice(index, 1);
      this.images.splice(index, 1);
    },
    send() {
      console.log("Send message:" + this.text);
      if (this.stompSocketClient && this.stompSocketClient.connected) {
        const msg = {
          userName: this.nickname,
          content: this.text,
          channel_id: 1,
          account_id: 2,
        };
        this.stompSocketClient.send(
          "/kafka/send-channel-message",
          JSON.stringify(msg),
          {}
        );
      }
    },
  },
};
</script>

<style>
.server-chatting-container {
  position: relative;
  /* display: -webkit-box;
  display: -ms-flexbox; */
  display: flex;
  height: 100%;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  /* -ms-flex-direction: column; */
  flex-direction: column;
  min-width: 0;
  min-height: 0;
  -webkit-box-flex: 1;
  /* -ms-flex: 1 1 auto; */
  flex: 1 1 auto;
}
.message-container {
  display: flex;
  position: relative;
  -webkit-box-flex: 1;
  flex: 1 1 auto;
  min-height: 0;
  min-width: 0;
  z-index: 0;
}
.server-chat-scroller {
  overflow: hidden scroll;
  padding-right: 0px;
  width: 100%;
}
.scroller-content {
  overflow-anchor: none;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  flex-direction: column;
  -webkit-box-pack: end;
  justify-content: flex-end;
  -webkit-box-align: stretch;
  align-items: stretch;
  min-height: 100%;
  display: flex;
  position: relative;
}
.scroller-inner {
  min-height: 0;
  list-style: none;
  padding: 0px;
}
.chat-message-wrapper {
  outline: none;
}
/* .chat-message-wrapper2 {
  margin-top: 1.0625rem;
  min-height: 2.75rem;
  padding-left: 72px;
  padding-top: 0.125rem;
  padding-bottom: 0.125rem;
  padding-right: 48px !important;
  position: relative;
  word-wrap: break-word;
  user-select: text;
  -webkit-box-flex: 0;
  flex: 0 0 auto;
} */
.others-chat-message-wrapper {
  margin-top: 1.0625rem;
  min-height: 2.75rem;
}
.primary-chat-message-wrapper {
  padding-left: 72px;
  padding-top: 0.125rem;
  padding-bottom: 0.125rem;
  padding-right: 48px !important;
  position: relative;
  word-wrap: break-word;
  user-select: text;
  -webkit-box-flex: 0;
  flex: 0 0 auto;
}
.chat-message-content {
  position: static;
  margin-left: 0;
  padding-left: 0;
  text-indent: 0;
}
.chat-avatar {
  pointer-events: auto;
  position: absolute;
  left: 16px;
  margin-top: calc(4px - 0.125rem);
  width: 40px;
  height: 40px;
  border-radius: 50%;
  overflow: hidden;
  cursor: pointer;
  user-select: none;
  -webkit-box-flex: 0;
  flex: 0 0 auto;
  z-index: 1;
}
.chat-avatar-header {
  display: block;
  position: relative;
  line-height: 1.375rem;
  min-height: 1.375rem;
  color: #72767d;
  white-space: break-spaces;
  margin: 0px;
}
.chat-user-name {
  font-size: 1rem;
  font-weight: 500;
  line-height: 1.375rem;
  color: var(--white-color);
  display: inline;
  vertical-align: baseline;
  position: relative;
  overflow: hidden;
  flex-shrink: 0;
}
.chat-time-stamp {
  font-size: 0.75rem;
  line-height: 1.375rem;
  color: #72767d;
  vertical-align: baseline;
  margin-left: 0.25rem;
  display: inline-block;
  height: 1.25rem;
  cursor: default;
  pointer-events: none;
  font-weight: 500;
}
.message-content {
  user-select: text;
  margin-left: -72px;
  padding-left: 72px;
  overflow: hidden;
  position: relative;
  text-indent: 0;
  font-size: 1rem;
  line-height: 1.375rem;
  white-space: break-spaces;
  word-wrap: break-word;
  color: #dcddde;
  font-weight: 400;
}
.channel-message-input-form {
  position: relative;
  /* -ms-flex-negative: 0; */
  flex-shrink: 0;
  padding-left: 16px;
  padding-right: 16px;
}
.channel-message-area {
  margin-bottom: 24px;
  background-color: #36393f;
  position: relative;
  width: 100%;
  text-indent: 0;
  border-radius: 8px;
}
.channel-message-scrollbar-container {
  /* overflow-x: hidden;
  overflow-y: scroll; */
  background-color: #40444b;
  border-radius: 8px;
  max-height: 350px;
  /* height: 60px; */
}
.scrollbar-ghost::-webkit-scrollbar {
  width: 14px;
  height: 14px;
}
.scrollbar-ghost::-webkit-scrollbar-corner {
  border: none;
  background: none;
}
.scrollbar-ghost::-webkit-scrollbar-thumb {
  background-color: rgba(0, 0, 0, 0.4);
  border-width: 3px;
  border-radius: 7px;
  background-clip: padding-box;
}
.scrollbar-ghost::-webkit-scrollbar-track {
  border-width: initial;
  border-color: transparent;
  background-color: rgba(0, 0, 0, 0.1);
}

.channel-message-form-inner-button {
  display: flex;
  position: relative;
  padding-left: 16px;
}
.message-attachment-divider {
  z-index: 1;
  height: 0;
  border-top: thin solid hsla(0, 0%, 100%, 0.06);
  /* display: -webkit-box;
  display: -ms-flexbox; */
  display: flex;
  -webkit-box-align: center;
  /*  -ms-flex-align: center; */
  align-items: center;
  -webkit-box-pack: center;
  /* -ms-flex-pack: center; */
  justify-content: center;
  position: relative;
  -webkit-box-flex: 0;
  /* -ms-flex: 0 0 auto; */
  flex: 0 0 auto;
  pointer-events: none;
  /* -webkit-box-sizing: border-box; */
  box-sizing: border-box;
  --divider-color: hsl(359, calc(var(1, 1) * 82.6%), 59.4%);
}
.channel-attachment-area {
  gap: 24px;
  margin: 0 0 2px 6px;
  padding: 20px 10px 10px;
  overflow-x: auto;
  display: flex;
}
.upload-attachments {
  display: inline-flex;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  /* -ms-flex-direction: column; */
  flex-direction: column;
  background-color: #2f3136;
  border-radius: 4px;
  margin: 0;
  padding: 8px;
  position: relative;
  min-width: 200px;
  max-width: 200px;
  max-height: 200px;
}
.message-upload-container {
  display: flex;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  /* -ms-flex-direction: column; */
  flex-direction: column;
  height: 100%;
}
.message-upload-image-container {
  margin-top: auto;
  position: relative;
  min-height: 0;
}
.message-upload-filename-container {
  margin-top: auto;
}
.message-upload-actionbar-container {
  position: absolute;
  top: 0;
  right: 0;
}
.message-upload-input {
  position: relative;
  width: 0;
  height: 0;
  pointer-events: none;
}
.message-attach-button-wrapper {
  position: sticky;
  -webkit-box-flex: 0;
  flex: 0 0 auto;
  align-self: stretch;
}
.message-attach-button {
  height: 44px;
  padding: 10px 16px;
  position: sticky;
  top: 0;
  cursor: pointer;
  margin-left: -16px;
  width: auto;
  background: transparent;
  border: 0;
  margin: 0;
  display: flex;
  -webkit-box-pack: center;
  justify-content: center;
  -webkit-box-align: center;
  align-items: center;
  box-sizing: border-box;
  border-radius: 3px;
  font-size: 14px;
  font-weight: 500;
  line-height: 16px;
}
.attach-button-inner {
  height: 24px;
}
.attach-button {
  width: 24px;
  height: 24px;
  background-image: url("../assets/attach-button.svg");
}
.channel-message-input-area {
  padding: 0px;
  background-color: transparent;
  resize: none;
  border: none;
  appearance: none;
  box-sizing: border-box;
  font-weight: 400;
  font-size: 1rem;
  line-height: 1.375rem;
  width: 100%;
  min-height: 44px;
  color: #dcddde;
  position: relative;
  margin-left: 24px;
}
.channel-message-input-wrapper {
  outline: none;
  overflow-wrap: break-word;
  -webkit-user-modify: read-write-plaintext-only;
  /*   padding-bottom: 11px;
  padding-top: 11px;
  padding-right: 10px; */
  caret-color: #dcddde;
  position: absolute;
  left: 0;
  right: 10px;
  text-align: left;
  word-break: break-word;
  white-space: break-spaces !important;
  font-size: 1rem;
  line-height: 1.375rem;
  user-select: text;
  color: #dcddde;
  font-weight: 400;
  width: 100%;
  background-color: transparent;
  border: none;
  height: 90%;
  resize: none;
  /* margin-top: 6px; */
  /*   outline: none;
  overflow-wrap: break-word;
  line-height: 1.375rem;
  white-space: break-spaces !important;
  text-align: left;
  position: absolute;
  left: 0;
  right: 10px;
  height: 100px; */
}
.upload-chat-image-icon {
  height: 24px;
  position: relative;
  width: 24px;
}
.spoiler-wrapper {
  display: flex;
  -webkit-box-pack: center;
  justify-content: center;
  height: 100%;
}
.attach-image {
  border-radius: 3px;
  max-width: 100%;
  object-fit: contain;
}
.filename-wrapper {
  margin-top: 8px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  font-size: 14px;
  line-height: 18px;
  color: #dcddde;
}
.actionbar-wrapper {
  position: absolute;
  right: 0;
  z-index: 1;
  transform: translate(25%, -25%);
  padding: 0;
}
.actionbar-wrapper2 {
  background-color: #36393f;
  box-shadow: 0 0 0 1px rgba(4, 4, 5, 0.15);
  display: grid;
  grid-auto-flow: column;
  box-sizing: border-box;
  height: 32px;
  border-radius: 4px;
  -webkit-box-align: center;
  align-items: center;
  -webkit-box-pack: start;
  justify-content: flex-start;
  user-select: none;
  transition: box-shadow 0.1s ease-out, -webkit-box-shadow 0.1s ease-out;
  position: relative;
  overflow: hidden;
}
.remove-attachment-button {
  display: flex;
  -webkit-box-align: center;
  align-items: center;
  -webkit-box-pack: center;
  justify-content: center;
  height: 24px;
  padding: 4px;
  min-width: 24px;
  -webkit-box-flex: 0;
  flex: 0 0 auto;
  cursor: pointer;
  position: relative;
}
.trashcan {
  width: 24px;
  height: 24px;
  background-image: url("../assets/trashcan.svg");
}
</style>
