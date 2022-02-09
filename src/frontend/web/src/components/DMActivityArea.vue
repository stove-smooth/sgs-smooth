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
      <VEmojiPicker
        v-show="this.replyEmojiPopout"
        class="reply-emoji-picker-popout"
        labelSearch="Search"
        lang="pt-BR"
        @select="onSelectReplyEmoji"
      />
      <div class="height-100">
        <div class="scroller-content">
          <ol id="server-chat-scroll-bottom" class="scroller-inner">
            <div v-for="(item, index) in receiveList" :key="item.id">
              <div
                class="message-date-divider"
                v-if="
                  index == 0 ||
                  (index > 0 &&
                    receiveList[index - 1].date != receiveList[index].date)
                "
              >
                <span class="date-content">{{ receiveList[index].date }}</span>
              </div>
              <li
                class="chat-message-wrapper"
                @mouseover="messageHover(item.id)"
                @mouseleave="messageHover('')"
                v-bind:class="{
                  'selected-message-area':
                    messageHovered === item.id || messagePlusMenu === item.id,
                }"
              >
                <!--내가 연속적으로 보낸 메시지와 아닌 메시지가 구별됨-->
                <div
                  class="primary-chat-message-wrapper"
                  v-bind:class="{
                    'others-chat-message-wrapper':
                      item.isOther || item.parentName != null,
                    'message-replying':
                      directMessageReplyId !== '' &&
                      directMessageReplyId.messageInfo.id == item.id,
                  }"
                >
                  <!--메세지답장-->
                  <div
                    v-if="item.parentName != null"
                    class="message-reply-content"
                  >
                    <div class="reply-accessories" />
                    {{ item.parentName }}{{ item.parentContent }}
                  </div>
                  <div class="chat-message-content">
                    <template v-if="item.isOther || item.parentName != null">
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
                    <!--메세지 수정의 UI가 구분됨-->
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
                        <div class="channel-message-button-wrapper">
                          <div class="display-flex margin-right-8px">
                            <button
                              @click="openReplyEmojiPopout(item.id)"
                              class="emoji-button"
                              tabindex="0"
                              aria-label="이모티콘 선택하기"
                              type="button"
                            >
                              <svg
                                v-if="replyEmojiPopout"
                                class="yellow-emotion"
                              ></svg>
                              <svg v-else class="add-emotion"></svg>
                            </button>
                          </div>
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
                    <!--정말 삭제하시겠어요?-->
                    <div
                      class="channel-message-edit-tool-area"
                      v-if="directMessageReadyToDelete == item.id"
                    >
                      정말 삭제하시겠어요?
                      <span
                        class="highlight-text contents clickable"
                        @click="cancelDelete()"
                      >
                        취소
                      </span>
                      •
                      <span
                        class="highlight-text contents clickable red-color"
                        @click="deleteMessage(item.id)"
                      >
                        댓글 삭제
                      </span>
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
                        v-show="false"
                        class="chat-action-button"
                        aria-label="반응 추가하기"
                        role="button"
                        tabindex="0"
                      >
                        <svg class="add-emotion"></svg>
                      </div>
                      <!--내꺼면 수정아니면 답장-->
                      <div
                        v-if="item.userId == getUserId"
                        @click="setMessageEditId(item.id)"
                        class="chat-action-button"
                        aria-label="수정하기"
                        role="button"
                        tabindex="0"
                      >
                        <svg class="edit-pencil"></svg>
                      </div>
                      <div
                        v-else
                        @click="MessageReply(item)"
                        class="chat-action-button"
                        aria-label="답장하기"
                        role="button"
                        tabindex="0"
                      >
                        <svg class="reply-button"></svg>
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
        <div
          class="attached-bar"
          v-if="
            directMessageReplyId !== '' &&
            directMessageReplyId.channel == this.$route.params.id
          "
        >
          <div>
            <div class="clip-container">
              <div class="base-container">
                <div class="reply-bar">
                  <div role="button" tabindex="0">
                    <div class="reply-label-container">
                      <span class="large-description">
                        {{ directMessageReplyId.messageInfo.name }}
                      </span>
                      님에게 답장하는 중
                    </div>
                  </div>
                  <div class="align-items-center">
                    <div
                      class="reply-close-button"
                      @click="setDirectMessageReplyId('')"
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
import { sendImageDirectChatting, readDMChatMessage } from "../api/index";
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
      thumbnailFiles: [],
      receiveList: [],
      emojiPopout: false,
      replyEmojiPopout: "",
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
    ...mapState("user", ["nickname", "userimage"]),
    ...mapState("utils", ["stompSocketClient", "stompSocketConnected"]),
    ...mapState("server", ["messagePlusMenu", "messageEditId"]),
    ...mapState("dm", ["directMessageReplyId", "directMessageReadyToDelete"]),
    ...mapGetters("user", ["getUserId"]),
  },
  async created() {
    await this.readChannelMessage();
    this.stompSocketClient.subscribe(
      "/topic/direct/" + this.$route.params.id,
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
    ...mapMutations("server", ["setMessagePlusMenu", "setMessageEditId"]),
    ...mapMutations("dm", [
      "setDirectMessageReplyId",
      "setDirectMessageReadyToDelete",
    ]),
    sendMessage(e) {
      if (e.keyCode == 13 && !e.shiftKey && this.stompSocketConnected) {
        if (this.text.trim().length == 0 && this.images.length == 0) {
          return;
        }
        if (this.directMessageReplyId) {
          this.reply();
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
          channelId: this.$route.params.id,
          userId: this.getUserId,
          name: this.nickname,
          profileImage: this.userimage,
        };
        this.stompSocketClient.send(
          "/kafka/send-direct-message",
          JSON.stringify(msg),
          {}
        );
      }
    },
    reply() {
      const msg = {
        content: this.text,
        channelId: this.$route.params.id,
        userId: this.getUserId,
        name: this.nickname,
        profileImage: this.userimage,
        parentId: this.directMessageReplyId.messageInfo.id,
        parentName: this.directMessageReplyId.messageInfo.name,
        parentContent: this.directMessageReplyId.messageInfo.message,
        type: "reply",
      };
      this.stompSocketClient.send(
        "/kafka/send-direct-reply",
        JSON.stringify(msg),
        {}
      );
      this.setDirectMessageReplyId("");
    },
    modify(id, content) {
      this.modifyLogMessage = "";
      if (this.stompSocketClient && this.stompSocketConnected) {
        if (content.trim().length == 0) {
          this.modifyLogMessage = "내용을 입력한 후 수정해주세요.";
        }
        const msg = {
          id: id,
          content: content,
          userId: this.getUserId,
          type: "modify",
        };
        this.stompSocketClient.send(
          "/kafka/send-direct-modify",
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
    deleteMessage(id) {
      const msg = {
        id: id,
        userId: this.getUserId,
        type: "delete",
      };
      this.stompSocketClient.send(
        "/kafka/send-direct-delete",
        JSON.stringify(msg),
        {}
      );
      let array = this.receiveList.filter((element) => element.id !== id);
      this.receiveList = array;
      this.setDirectMessageReadyToDelete(false);
    },
    cancelDelete() {
      this.setDirectMessageReadyToDelete(false);
    },
    MessageReply(messagePlusMenu) {
      const message = {
        channel: this.$route.params.id,
        messageInfo: messagePlusMenu,
      };
      this.setDirectMessageReplyId(message);
    },
    async sendPicture() {
      const formData = new FormData();
      /* for (let i = 0; i < this.images.length; i++) {
        formData.append("image", this.thumbnailFiles[i]);
      } */
      formData.append("image", this.images[0]);
      formData.append("thumbnail", this.thumbnailFiles[0]);
      formData.append("userId", this.getUserId);
      formData.append("channelId", this.$route.params.id);
      formData.append("type", "direct");
      formData.append("fileType", "image");
      formData.append("name", this.nickname);
      formData.append("profileImage", this.userimage);
      try {
        await sendImageDirectChatting(formData);
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
      if (this.replyEmojiPopout) {
        var condition3 = e.target.parentNode.childNodes[0]._prevClass;
        var condition4 = e.target.parentNode.className;
        if (
          condition4 !== "container-search" &&
          condition4 !== "container-emoji" &&
          condition4 !== "reply-emoji-picker-popout" &&
          condition4 !== "svg" &&
          condition4 !== "emoji-button" &&
          condition4 !== "reply-emoji-picker-popout emoji-picker" &&
          condition3 !== "category"
        ) {
          this.replyEmojiPopout = false;
        }
      }
    },
    convertFromStringToDate(responseDate) {
      var time = {};
      let dateComponents = responseDate.split("T");
      dateComponents[0].split("-");
      let timePieces = dateComponents[1].split(":");
      let transDate;
      if (parseInt(timePieces[0]) + 9 < 24) {
        time.hour = parseInt(timePieces[0]) + 9;
        let tempDate = new Date(dateComponents[0]);
        transDate = tempDate.toLocaleDateString();
      } else {
        time.hour = parseInt(timePieces[0]) + 9 - 24;
        var newDate = new Date(dateComponents[0]);
        newDate.setDate(newDate.getDate() + 1);
        transDate = newDate.toLocaleDateString();
      }
      time.minutes = parseInt(timePieces[1]);
      return [transDate, time.hour + ":" + time.minutes];
    },
    onSelectEmoji(emoji) {
      this.text += emoji.data;
    },
    onSelectReplyEmoji(emoji) {
      for (var i = 0; i < this.receiveList.length; i++) {
        if (this.receiveList[i].id == this.replyEmojiPopout) {
          this.receiveList[i].message += emoji.data;
          break;
        }
      }
    },
    openEmojiPopout() {
      this.emojiPopout = !this.emojiPopout;
    },
    openReplyEmojiPopout(messageId) {
      if (this.replyEmojiPopout) {
        this.replyEmojiPopout = "";
      } else {
        this.replyEmojiPopout = messageId;
      }
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
      const { scrollHeight, scrollTop } = e.target;
      if (scrollTop == 0) {
        if (this.more) {
          this.prevScrollHeight = scrollHeight;
          this.page++;
          await this.readChannelMessage();
        }
      }
    },
    async readChannelMessage() {
      try {
        const result = await readDMChatMessage(
          this.$route.params.id,
          this.page
        );

        if (result.data.result.length == 50) {
          this.more = true;
        } else {
          this.more = false;
        }
        var array = [];
        for (var i = 0; i < result.data.result.length; i++) {
          //시간을 한국 시간+디스코드에 맞게 변환
          console.log("message입니다.", result.data.result[i]);
          const translatedTime = this.convertFromStringToDate(
            result.data.result[i].time
          );
          result.data.result[i].date = translatedTime[0];
          result.data.result[i].time = translatedTime[1];
          //사진이라면 image태그를 붙여줌.
          result.data.result[i].message = this.urlify(
            result.data.result[i].message
          );
          //동일 시간(분)에 동일 유저가 보냈다면 다른 같은 메시지로 묶음.
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
            scrollRef.scrollTop =
              scrollRef.scrollHeight - this.prevScrollHeight;
          });
        }
      } catch (err) {
        console.log(err.response);
      }
    },
    isSameTime(prev, current) {
      //먼저 날이 같을때.
      if (prev.date == current.date) {
        if (prev.time == current.time) {
          return true;
        } else {
          return false;
        }
      } else {
        //date가 다르다면 같은 시간이 아님.
        return false;
      }
    },
  },
};
</script>

<style></style>
