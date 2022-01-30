<template>
  <div class="server-chatting-container">
    <div
      class="thin-scrollbar server-chat-scroller"
      ref="scrollRef"
      @scroll="handleScroll"
    >
      <VEmojiPicker
        v-show="this.emojiPopout"
        class="emoji-picker-popout"
        labelSearch="Search"
        lang="pt-BR"
        @select="onSelectEmoji"
      />
      <div class="height-100">
        <div class="scroller-content">
          <ol id="server-chat-scroll-bottom" class="scroller-inner">
            <div v-for="item in receiveList" :key="item.id">
              <li
                class="chat-message-wrapper"
                @mouseover="messageHover(item.id)"
                @mouseleave="messageHover('')"
                v-bind:class="{
                  'selected-message-area':
                    messageHovered === item.id || messagePlusMenu === item.id,
                }"
              >
                <div
                  class="primary-chat-message-wrapper"
                  v-bind:class="{
                    'others-chat-message-wrapper': item.isOther,
                    'message-replying': messageReplyId.id === item.id,
                  }"
                >
                  <div class="chat-message-content">
                    <template v-if="item.isOther">
                      <img
                        :src="item.profileImage"
                        class="chat-avatar clickable"
                        alt="image"
                      />
                      <h2 class="chat-avatar-header">
                        <span class="chat-user-name">{{ item.name }}</span>
                        <span class="chat-time-stamp">{{ item.time }}</span>
                      </h2>
                    </template>

                    <div v-if="messageEditId === item.id">
                      <div class="channel-message-edit-area">
                        <div class="channel-message-input-area">
                          <textarea
                            id="input-text-wrapper"
                            class="channel-message-input-wrapper"
                            aria-haspopup="listbox"
                            v-model="item.message"
                          ></textarea>
                        </div>
                      </div>
                      <div class="channel-message-edit-tool-area">
                        댓글 수정
                        <span
                          class="highlight-text contents clickable"
                          @click="cancelModify()"
                        >
                          취소
                        </span>
                        • 댓글 수정
                        <span
                          class="highlight-text contents clickable"
                          @click="modify(item.id, item.message)"
                        >
                          저장
                        </span>
                      </div>
                      <p class="warning" v-show="modifyLogMessage">
                        {{ modifyLogMessage }}
                      </p>
                    </div>
                    <div v-else class="message-content">
                      <template v-if="item.message.includes('img')"
                        ><div v-html="item.message"></div
                      ></template>
                      <template v-else
                        ><div>{{ item.message }}</div></template
                      >
                    </div>
                  </div>
                  <div
                    class="chat-message-plus-action-container"
                    v-show="
                      messageHovered === item.id || messagePlusMenu === item.id
                    "
                  >
                    <div class="actionbar-wrapper2">
                      <div
                        class="chat-action-button"
                        aria-label="반응 추가하기"
                        role="button"
                        tabindex="0"
                      >
                        <svg class="add-emotion"></svg>
                      </div>
                      <!--내꺼면 수정아니면 답장-->
                      <div
                        @click="setMessageEditId(item.id)"
                        v-show="false"
                        class="chat-action-button"
                        aria-label="수정하기"
                        role="button"
                        tabindex="0"
                      >
                        <svg class="edit-pencil"></svg>
                      </div>
                      <div
                        @click="setMessageReplyId(item)"
                        class="chat-action-button"
                        aria-label="답장하기"
                        role="button"
                        tabindex="0"
                      >
                        <svg class="reply-button"></svg>
                      </div>
                      <div
                        class="chat-action-button"
                        aria-label="스레드 만들기"
                        role="button"
                        tabindex="0"
                      >
                        <svg class="thread-icon"></svg>
                      </div>
                      <div
                        :data-key="item.id"
                        @click="clickPlusAction($event, item)"
                        class="chat-action-button"
                        aria-label="추가 기능"
                        role="button"
                        tabindex="0"
                      >
                        <svg class="row-plus-action"></svg>
                      </div>
                    </div>
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
        <div class="attached-bar" v-if="messageReplyId !== ''">
          <div>
            <div class="clip-container">
              <div class="base-container">
                <div class="reply-bar">
                  <div role="button" tabindex="0">
                    <div class="reply-label-container">
                      <span class="large-description">
                        {{ messageReplyId.name }}
                      </span>
                      님에게 답장하는 중
                    </div>
                  </div>
                  <div class="align-items-center">
                    <div
                      class="reply-close-button"
                      @click="setMessageReplyId('')"
                    >
                      <svg class="small-close-button"></svg>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
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
                            class="chat-action-button"
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
                @keydown="sendMessage"
                @keyup="initialMessage"
                placeholder="#잡담에 메세지 보내기"
              ></textarea>
            </div>
            <div class="channel-message-button-wrapper">
              <div class="display-flex margin-right-8px">
                <button
                  @click="openEmojiPopout"
                  class="emoji-button"
                  tabindex="0"
                  aria-label="이모티콘 선택하기"
                  type="button"
                >
                  <svg v-if="emojiPopout" class="yellow-emotion"></svg>
                  <svg v-else class="add-emotion"></svg>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { VEmojiPicker } from "v-emoji-picker";

import { converToThumbnail, dataUrlToFile } from "../utils/common.js";
import { mapState, mapMutations, mapGetters } from "vuex";
import { sendImageChatting, readChatMessage } from "../api/index";
export default {
  components: {
    VEmojiPicker,
  },
  data() {
    return {
      messageHovered: "",
      text: "",
      images: [],
      thumbnails: [],
      receiveList: [],
      thumbnailFiles: [],
      emojiPopout: false,
      page: 0,
      more: false,
      prevScrollHeight: 0,
      modifyLogMessage: "",
    };
  },
  mounted() {
    window.addEventListener("click", this.onClick);
  },
  computed: {
    ...mapState("user", ["nickname"]),
    ...mapState("utils", ["stompSocketClient", "stompSocketConnected"]),
    ...mapState("server", [
      "messagePlusMenu",
      "messageReplyId",
      "messageEditId",
    ]),
    ...mapGetters("user", ["getUserId"]),
  },
  async created() {
    await this.readChannelMessage();
    this.stompSocketClient.subscribe(
      "/topic/group/" + this.$route.params.channelid,
      (res) => {
        console.log("구독으로 받은 메시지 입니다.", res.body);
        const translatedTime = this.convertFromStringToDate(
          JSON.parse(res.body).time
        );
        const receivedForm = JSON.parse(res.body);
        receivedForm.date = translatedTime[0];
        receivedForm.time = translatedTime[1];
        receivedForm.message = this.urlify(receivedForm.message);
        let isOther = true;
        if (this.receiveList.length > 0) {
          const timeResult = this.isSameTime(
            this.receiveList[this.receiveList.length - 1],
            receivedForm
          );
          if (
            timeResult &&
            this.receiveList[this.receiveList.length - 1].userId ==
              receivedForm.userId
          ) {
            isOther = false;
          }
        }
        receivedForm.isOther = isOther;

        this.receiveList.push(receivedForm);
        this.$nextTick(function () {
          this.scrollToBottom();
        });
      }
    );
  },
  methods: {
    ...mapMutations("utils", ["setClientX", "setClientY"]),
    ...mapMutations("server", [
      "setMessagePlusMenu",
      "setMessageReplyId",
      "setMessageEditId",
    ]),
    sendMessage(e) {
      if (e.keyCode == 13 && !e.shiftKey && this.stompSocketConnected) {
        if (this.text.trim().length == 0 && this.images.length == 0) {
          return;
        }
        if (this.images.length > 0) {
          this.sendPicture();
        }
        if (this.text) {
          this.send();
        }
      }
    },
    initialMessage(e) {
      if (e.keyCode == 13 && !e.shiftKey && this.stompSocketConnected) {
        this.text = "";
      }
    },
    async uploadImage() {
      for (var i = 0; i < this.$refs["images"].files.length; i++) {
        this.images.push(this.$refs["images"].files[i]);
        let thumbnail = await converToThumbnail(this.$refs["images"].files[i]);
        let thumbnailFile = await dataUrlToFile(thumbnail);
        this.thumbnails.push(thumbnail);
        this.thumbnailFiles.push(thumbnailFile);
        console.log("image", this.images, "thumbnail", this.thumbnails);
      }
    },
    deleteAttachment(index) {
      this.thumbnails.splice(index, 1);
      this.images.splice(index, 1);
    },
    send() {
      if (this.stompSocketClient && this.stompSocketConnected) {
        const msg = {
          content: this.text,
          channelId: this.$route.params.channelid,
          accountId: this.getUserId,
        };
        this.stompSocketClient.send(
          "/kafka/send-channel-message",
          JSON.stringify(msg),
          {}
        );
      }
    },
    modify(id, content) {
      this.modifyLogMessage = "";
      if (this.stompSocketClient && this.stompSocketConnected) {
        console.log(id, content);
        if (content.trim().length == 0) {
          this.modifyLogMessage = "내용을 입력한 후 수정해주세요.";
        }
        const msg = {
          id: id,
          content: content,
        };
        this.stompSocketClient.send(
          "/kafka/send-channel-modify",
          JSON.stringify(msg),
          {}
        );
        this.setMessageEditId("");
      }
    },
    cancelModify() {
      this.setMessageEditId("");
      this.modifyLogMessage = "";
    },
    async sendPicture() {
      const formData = new FormData();
      for (let i = 0; i < this.images.length; i++) {
        formData.append("image", this.thumbnailFiles[i]);
      }
      try {
        await sendImageChatting(
          formData,
          this.$route.params.channelid,
          this.getUserId
        );
        this.images = [];
        this.thumbnails = [];
      } catch (err) {
        console.log("errrr", err.response);
      }
    },
    messageHover(idx) {
      this.messageHovered = idx;
    },
    clickPlusAction(event, messageInfo) {
      const x = event.clientX;
      const y = event.clientY;
      this.setClientX(x);
      this.setClientY(y);
      this.setMessagePlusMenu(messageInfo);
    },
    onClick(e) {
      if (this.messagePlusMenu != null) {
        if (!e.target.parentNode.dataset.key) {
          this.setMessagePlusMenu(null);
        }
      }
      if (this.emojiPopout) {
        var condition1 = e.target.parentNode.childNodes[0]._prevClass;
        var condition2 = e.target.parentNode.className;
        if (
          condition2 !== "container-search" &&
          condition2 !== "container-emoji" &&
          condition2 !== "emoji-picker-popout" &&
          condition2 !== "svg" &&
          condition2 !== "emoji-button" &&
          condition2 !== "emoji-picker-popout emoji-picker" &&
          condition1 !== "category"
        ) {
          this.emojiPopout = false;
        }
      }
    },
    convertFromStringToDate(responseDate) {
      var time = {};
      let dateComponents = responseDate.split("T");
      dateComponents[0].split("-");
      let timePieces = dateComponents[1].split(":");

      if (parseInt(timePieces[0]) + 9 < 24) {
        time.hour = parseInt(timePieces[0]) + 9;
      } else {
        time.hour = parseInt(timePieces[0]) + 9 - 24;
      }
      time.minutes = parseInt(timePieces[1]);
      return [dateComponents[0], time.hour + ":" + time.minutes];
    },
    onSelectEmoji(emoji) {
      this.text += emoji.data;
    },
    openEmojiPopout() {
      this.emojiPopout = !this.emojiPopout;
    },
    urlify(text) {
      var urlRegex = /(https?:\/\/[^\s]+)/g;
      return text.replace(urlRegex, function (url) {
        return `<img alt="이미지" src="${url}"/>`;
      });
    },
    scrollToBottom() {
      let scrollRef = this.$refs["scrollRef"];
      scrollRef.scrollTop = scrollRef.scrollHeight;
    },
    async handleScroll(e) {
      const { scrollHeight, scrollTop, clientHeight } = e.target;
      console.log("scroll", scrollTop, scrollHeight, clientHeight);
      if (scrollTop == 0) {
        if (this.more) {
          this.prevScrollHeight = scrollHeight;
          this.page++;
          await this.readChannelMessage();
        }
      }
    },
    async readChannelMessage() {
      const result = await readChatMessage(
        this.$route.params.channelid,
        this.page
      );
      if (result.data.result.length == 50) {
        this.more = true;
      } else {
        this.more = false;
      }
      var array = [];
      for (var i = 0; i < result.data.result.length; i++) {
        const translatedTime = this.convertFromStringToDate(
          result.data.result[i].time
        );
        result.data.result[i].date = translatedTime[0];
        result.data.result[i].time = translatedTime[1];
        result.data.result[i].message = this.urlify(
          result.data.result[i].message
        );
        let isOther = true;
        if (i != 0) {
          const timeResult = this.isSameTime(
            result.data.result[i - 1],
            result.data.result[i]
          );
          if (
            timeResult &&
            result.data.result[i - 1].userId == result.data.result[i].userId
          ) {
            isOther = false;
          }
        }
        result.data.result[i].isOther = isOther;
        array.push(result.data.result[i]);
      }
      let newarray = array.concat(this.receiveList);
      this.receiveList = newarray;
      if (this.page == 0) {
        this.$nextTick(function () {
          this.scrollToBottom();
        });
      }
      if (this.prevScrollHeight != 0) {
        this.$nextTick(function () {
          let scrollRef = this.$refs["scrollRef"];
          scrollRef.scrollTop = scrollRef.scrollHeight - this.prevScrollHeight;
        });
      }
    },
    isSameTime(prevv, currentt) {
      let prevTime = prevv.time.split(":");
      let currentTime = currentt.time.split(":");
      if (prevv.date == currentt.date) {
        let interval =
          parseInt(currentTime[0]) * 60 +
          parseInt(currentTime[1]) -
          (parseInt(prevTime[0]) * 60 + parseInt(prevTime[1]));
        if (interval <= 1) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    },
  },
};
</script>

<style>
/**메세지 수정 */
.channel-message-edit-area {
  position: relative;
  width: 100%;
  text-indent: 0;
  border-radius: 8px;
  margin-top: 8px;
  background-color: #40444b;
}
.channel-message-edit-tool-area {
  padding: 7px 0;
  font-size: 12px;
  font-weight: 400;
  text-indent: 0;
  color: #dcddde;
}
.server-chatting-container {
  position: relative;
  display: flex;
  height: 100%;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  flex-direction: column;
  min-width: 0;
  min-height: 0;
  -webkit-box-flex: 1;
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
  flex: 1;
  align-items: flex-end;
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
  padding-left: 66px;
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
.attached-bar {
  background: #2f3136;
  border-top-left-radius: 8px;
  border-top-right-radius: 8px;
}
.channel-message-scrollbar-container {
  background-color: #40444b;
  border-radius: 8px;
  max-height: 350px;
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
  display: flex;
  -webkit-box-align: center;
  align-items: center;
  -webkit-box-pack: center;
  justify-content: center;
  position: relative;
  -webkit-box-flex: 0;
  flex: 0 0 auto;
  pointer-events: none;
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
.chat-action-button {
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
.chat-action-button:hover {
  background-color: #40444b;
}
.trashcan {
  width: 24px;
  height: 24px;
  background-image: url("../assets/trashcan.svg");
}
.chat-message-accessories {
  display: grid;
  grid-auto-flow: row;
  grid-row-gap: 0.25rem;
  text-indent: 0;
  min-height: 0;
  min-width: 0;
  padding-top: 0.125rem;
  padding-bottom: 0.125rem;
  position: relative;
}
.chat-message-attachment {
  justify-self: start;
  align-self: start;
  position: relative;
}
.chat-message-image-wrapper {
  width: 400px;
  height: 200px;
  cursor: pointer;
}
.chat-message-plus-action-container {
  position: absolute;
  right: 0;
  z-index: 1;
  top: -25px;
  padding: 0 14px 0 32px;
  opacity: 1;
  pointer-events: auto;
}
.add-emotion {
  width: 24px;
  height: 24px;
  background-image: url("../assets/add-emotion.svg");
}
.edit-pencil {
  width: 24px;
  height: 24px;
  background-image: url("../assets/edit-pencil.svg");
}
.row-plus-action {
  width: 20px;
  height: 20px;
  background-image: url("../assets/row-plus-action.svg");
}
.selected-message-area {
  background-color: #2f3136;
}
.message-replying {
  position: relative;
  background-color: rgba(53, 68, 129, 0.1);
  border-left: 1mm solid var(--discord-primary);
}
.clip-container {
  overflow: hidden;
  padding-top: 3px;
  margin-top: -3px;
}
.reply-bar {
  display: grid;
  grid-template-columns: 1fr auto;
  -webkit-box-align: center;
  align-items: center;
  border-top-left-radius: 8px;
  border-top-right-radius: 8px;
  background: #2f3136;
  cursor: pointer;
}
.reply-label-container {
  -webkit-box-flex: 1;
  flex: 1 1 auto;
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
  margin-left: 16px;
  font-size: 14px;
  line-height: 18px;
  color: #b9bbbe;
}
.reply-close-button {
  flex: 0 0 auto;
  cursor: pointer;
  color: #b9bbbe;
  line-height: 0;
  padding: 8px 18px 8px 16px;
}
.small-close-button {
  width: 15px;
  height: 15px;
  background-image: url("../assets/small-close-button.svg");
}
.reply-button {
  width: 20px;
  height: 20px;
  background-image: url("../assets/reply-button.svg");
}
.channel-message-button-wrapper {
  margin-right: -6px;
  display: flex;
  -webkit-box-orient: horizontal;
  -webkit-box-direction: normal;
  flex-direction: row;
  height: 44px;
  position: sticky;
  top: 0;
}
.emoji-button {
  cursor: pointer;
  max-height: 50px;
  display: flex;
  -webkit-box-align: center;
  align-items: center;
  -webkit-box-pack: center;
  justify-content: center;
  padding: 4px;
  margin-left: 4px;
  margin-right: 4px;
  border-radius: 5px;
  background: none;
}
.yellow-emotion {
  width: 24px;
  height: 24px;
  background-image: url("../assets/yellow-emotion.svg");
}
.emoji-picker-popout {
  background-color: #2f3136 !important;
  position: absolute;
  bottom: 70px;
  right: 0;
  z-index: 10;
}
</style>
