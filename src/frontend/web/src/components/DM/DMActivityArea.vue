<template>
  <div class="server-chatting-container">
    <div
      class="thin-scrollbar server-chat-scroller"
      ref="scrollRef"
      @scroll="handleScroll"
    >
      <!--일반 채팅 / 수정시 이모지 -->
      <VEmojiPicker
        v-show="this.emojiPopout"
        class="emoji-picker-popout"
        labelSearch="Search"
        lang="pt-BR"
        @select="onSelectEmoji"
      />
      <VEmojiPicker
        v-show="this.editEmojiPopout"
        class="reply-emoji-picker-popout"
        labelSearch="Search"
        lang="pt-BR"
        @select="onSelectEditEmoji"
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
                      (item.isOther && !item.calling) ||
                      item.parentName != null,
                    'message-replying':
                      directMessageReplyId !== '' &&
                      directMessageReplyId.messageInfo.id == item.id,
                    'margin-top-8px': item.calling,
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
                      <template v-if="item.calling"
                        ><svg class="dm-avatar dm_call"></svg
                      ></template>
                      <template v-else
                        ><img
                          :src="item.profileImage"
                          class="chat-avatar clickable"
                          alt="image"
                      /></template>
                      <h2 class="chat-avatar-header" v-if="!item.calling">
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
                              @click="openEditEmojiPopout(item.id)"
                              class="emoji-button"
                              tabindex="0"
                              aria-label="이모티콘 선택하기"
                              type="button"
                            >
                              <svg
                                v-if="editEmojiPopout"
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
                    <div v-else class="message-content display-flex">
                      <template
                        v-if="item.fileType && item.fileType == 'image'"
                      >
                        <div v-if="!imageLoading" class="loading-img"></div>
                        <div v-else v-html="item.thumbnail"></div>
                      </template>
                      <template v-else>
                        <template v-if="item.isInviteUrl">
                          <div v-html="item.message"></div>
                        </template>
                        <template v-else>{{ item.message }}</template>
                      </template>
                      <span v-if="item.calling" class="chat-time-stamp">{{
                        item.time
                      }}</span>
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
                        삭제
                      </span>
                    </div>
                  </div>
                  <div
                    class="chat-message-plus-action-container"
                    v-show="
                      (messageHovered === item.id ||
                        messagePlusMenu === item.id) &&
                      !item.calling
                    "
                  >
                    <div class="actionbar-wrapper2">
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
        <div class="chatting-state" v-if="messageTyper">
          {{ messageTyper }}님께서 입력하고 있어요
        </div>
        <div class="no-chatting-state-area" v-else></div>
      </div>
    </div>
  </div>
</template>

<script>
import { VEmojiPicker } from "v-emoji-picker";

import { converToThumbnail, dataUrlToFile } from "../../utils/common.js";
import { mapState, mapMutations, mapGetters } from "vuex";
import { sendImageDirectChatting, readDMChatMessage } from "../../api/index";
import { convertFromStringToDate } from "@/utils/common.js";
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
      editEmojiPopout: "",
      page: 0,
      more: false,
      prevScrollHeight: 0,
      modifyLogMessage: "",
      recentChatted: null,
      messageTyper: "",
      setTimeId: "",
      imageLoading: false,
      stompSocket: "",
    };
  },
  mounted() {
    window.addEventListener("click", this.onClick);
  },
  computed: {
    ...mapState("user", ["nickname", "userimage"]),
    ...mapState("utils", ["stompSocketClient", "stompSocketConnected"]),
    ...mapState("community", ["messagePlusMenu", "messageEditId"]),
    ...mapState("dm", [
      "directMessageReplyId",
      "directMessageReadyToDelete",
      "directMessageMemberList",
    ]),
    ...mapGetters("user", ["getUserId"]),
    ...mapState("dm", ["directMessageList"]),
  },
  async created() {
    //들어온 채널의 상태를 보냄.

    const msg = {
      user_id: this.getUserId,
      channel_id: `r-${this.$route.params.id}`,
      type: "state",
    };
    this.stompSocketClient.send("/kafka/join-channel", JSON.stringify(msg), {});
    await this.readChannelMessage();
    this.stompSocket = this.stompSocketClient.subscribe(
      "/topic/direct/" + this.$route.params.id,
      async (res) => {
        console.log("구독으로 받은 메시지 입니다.", res.body);
        /**메세지의 종류: 일반 채팅, 이미지 채팅, 수정, 삭제, 답장, 타이핑 상태  */
        //한국시간에 맞게 시간 커스텀
        const receivedForm = JSON.parse(res.body);
        if (
          receivedForm.type != "typing" &&
          receivedForm.type != "delete" &&
          receivedForm.type != "connect" &&
          receivedForm.type != "disconnect"
        ) {
          console.log("날짜가 있는 메시지인 경우");
          const translatedTime = convertFromStringToDate(receivedForm.time);
          receivedForm.date = translatedTime[0];
          receivedForm.time = translatedTime[1];
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
        }
        //초대장 관련
        if (
          receivedForm.message &&
          receivedForm.message.startsWith("<~inviting~>")
        ) {
          let callingMessage = receivedForm.message.replace("<~inviting~>", "");
          receivedForm.isInviteUrl = true;
          receivedForm.message = this.transUrl(callingMessage);
        }
        //이미지를 보낼시 이미지 처리
        if (receivedForm.fileType && receivedForm.fileType == "image") {
          receivedForm.thumbnail = this.urlify(receivedForm.thumbnail);
        }

        //dm calling 메시지 받기
        if (
          receivedForm.message &&
          receivedForm.message.startsWith("<~dmcalling~>")
        ) {
          let callingMessage = receivedForm.message.replace(
            "<~dmcalling~>",
            ""
          );
          receivedForm.message = callingMessage;
          receivedForm.calling = true;
          receivedForm.isOther = true;
        }
        //메세지 타입이 충족되는 경우 모두 메시지 리스트에 넣고, 렌더링이 된다면 스크롤을 바닥으로 내림
        if (
          receivedForm.type != "typing" &&
          receivedForm.type != "modify" &&
          receivedForm.type != "delete" &&
          receivedForm.type != "connect" &&
          receivedForm.type != "disconnect"
        ) {
          this.imageLoading = false;
          this.receiveList.push(receivedForm);
          await this.$nextTick(function () {
            this.scrollToBottom();
          });
          this.imageLoading = true;
        }
        //수정 구독 메시지 수신시,현재 로드된 메시지 중 수정한 메시지가 있다면 수정을 해준다.
        if (receivedForm.type == "modify") {
          console.log("수정해야함");
          for (let i = 0; i < this.receiveList.length; i++) {
            if (this.receiveList[i].id == receivedForm.id) {
              this.receiveList[i].message = receivedForm.message;
            }
          }
        }
        //삭제 구독 메시지 수신시,현재 로드된 메시지 중 삭제한 메시지가 있다면 삭제해준다.
        if (receivedForm.type == "delete") {
          let array = this.receiveList.filter(
            (element) => element.id !== receivedForm.id
          );
          this.receiveList = array;
        }
        //타이핑 구독 수신. 마지막으로 타이핑친 사람의 이름은 3초뒤에 사라진다.
        if (receivedForm.type == "typing") {
          this.messageTyper = receivedForm.name;
        }
        //같은 방 유저가 disconnect일경우.
        if (receivedForm.type == "disconnect") {
          for (
            let i = 0;
            i < this.directMessageMemberList.members.length;
            i++
          ) {
            if (
              this.directMessageMemberList.members[i].id == receivedForm.userId
            ) {
              this.directMessageMemberList.members[i].state = "offline";
            }
          }
        }
        if (receivedForm.type == "connect") {
          for (
            let i = 0;
            i < this.directMessageMemberList.members.length;
            i++
          ) {
            if (
              this.directMessageMemberList.members[i].id == receivedForm.userId
            ) {
              this.directMessageMemberList.members[i].state = "online";
            }
          }
        }
      }
    );
  },
  watch: {
    /**메세지 타이핑 상태를 서버에 알리기 위한 로직
     * text가 변경될 경우 , 10초에 텀을 두고 상태를 확인하고 서버에 다시 알릴지 결정한다.
     */
    text() {
      if (this.recentChatted) {
        //채팅한 기록이 있을 경우
        if (new Date() - this.recentChatted >= 6000) {
          this.recentChatted = new Date();
          const msg = {
            content: this.nickname,
            channelId: this.$route.params.id,
            type: "typing",
          };
          this.stompSocketClient.send(
            "/kafka/send-direct-typing",
            JSON.stringify(msg),
            {}
          );
        } else {
          // 10초가 지나지 않아 메세지 입력 상태를 보내지 않는다.
        }
      } else {
        //최근에 채팅한 적이 없을 경우
        this.recentChatted = new Date();
        const msg = {
          content: this.nickname,
          channelId: this.$route.params.id,
          type: "typing",
        };
        this.stompSocketClient.send(
          "/kafka/send-direct-typing",
          JSON.stringify(msg),
          {}
        );
      }
    },
    //채팅 치는 사람을 표시하기 위함
    messageTyper(newVal, oldVal) {
      if (oldVal) {
        if (this.setTimeId) {
          clearTimeout(this.setTimeId);
        }
      }
      this.setTimeId = setTimeout(() => {
        this.messageTyper = "";
      }, 3000);
    },
  },
  methods: {
    ...mapMutations("utils", ["setClientX", "setClientY"]),
    ...mapMutations("community", ["setMessagePlusMenu", "setMessageEditId"]),
    ...mapMutations("dm", [
      "setDirectMessageReplyId",
      "setDirectMessageReadyToDelete",
    ]),
    sendMessage(e) {
      //enter시 메시지를 보낸다.
      if (e.keyCode == 13 && !e.shiftKey && this.stompSocketConnected) {
        //단, 텍스트 내용이 모두 스페이스 혹은 엔터로만 이루어져있다면 메시지를 보내지 않는다.
        if (this.text.trim().length == 0 && this.images.length == 0) {
          return;
        }
        //답장/일반메시지/사진메시지를 구분한다.
        if (this.directMessageReplyId) {
          this.reply();
        }
        if (this.images.length > 0) {
          this.sendPicture();
        }
        if (this.text) {
          this.send();
        }
        if (this.directMessageList[0].id != this.$route.params.id) {
          if (this.directMessageList) {
            for (let i = 0; i < this.directMessageList.length; i++) {
              if (this.directMessageList[i].id == this.$route.params.id) {
                let dmUpdated = this.directMessageList.splice(i, 1);
                this.directMessageList.unshift(dmUpdated[0]);
                return;
              }
            }
          }
        }
      }
    },
    //메시지를 보낸 후 메시지를 초기화한다.
    initialMessage(e) {
      if (e.keyCode == 13 && !e.shiftKey && this.stompSocketConnected) {
        this.text = "";
      }
    },
    //이미지를 썸네일로 변환해 사용자에게 미리 보여준다.
    async uploadImage() {
      this.images = [];
      this.thumbnails = [];
      this.thumbnailFiles = [];
      for (var i = 0; i < this.$refs["images"].files.length; i++) {
        this.images.push(this.$refs["images"].files[i]);
        let thumbnail = await converToThumbnail(this.$refs["images"].files[i]);
        let thumbnailFile = await dataUrlToFile(thumbnail);
        this.thumbnails.push(thumbnail);
        this.thumbnailFiles.push(thumbnailFile);
      }
    },
    //보낼 이미지 목록 중 원하는 이미지를 삭제할 수 있다.
    deleteAttachment(index) {
      this.thumbnails.splice(index, 1);
      this.images.splice(index, 1);
    },
    send() {
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
          channelId: this.$route.params.id,
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
        channelId: this.$route.params.id,
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
    //메시지 추가 기능을 위한 마우스 좌표
    clickPlusAction(event, messageInfo) {
      const x = event.clientX;
      const y = event.clientY;
      this.setClientX(x);
      this.setClientY(y);
      this.setMessagePlusMenu(messageInfo);
    },
    onClick(e) {
      //메시지 플러스 메뉴가 등장한 상태에서 다른 영역을 클릭하면 메시지 플러스 메뉴는 꺼진다.
      if (this.messagePlusMenu != null) {
        if (!e.target.parentNode.dataset.key) {
          this.setMessagePlusMenu(null);
        }
      }
      //이미지 팝아웃이 등장한 상태에서 다른 영역을 클릭하면 팝아웃은 꺼진다.
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
      if (this.editEmojiPopout) {
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
          this.editEmojiPopout = false;
        }
      }
    },
    onSelectEmoji(emoji) {
      this.text += emoji.data;
    },
    onSelectEditEmoji(emoji) {
      for (var i = 0; i < this.receiveList.length; i++) {
        if (this.receiveList[i].id == this.editEmojiPopout) {
          this.receiveList[i].message += emoji.data;
          break;
        }
      }
    },
    openEmojiPopout() {
      this.emojiPopout = !this.emojiPopout;
    },
    openEditEmojiPopout(messageId) {
      if (this.editEmojiPopout) {
        this.editEmojiPopout = "";
      } else {
        this.editEmojiPopout = messageId;
      }
    },
    urlify(text) {
      var urlRegex = /(https?:\/\/[^\s]+)/g;
      return text.replace(urlRegex, function (url) {
        return `<img alt="이미지" src="${url}"/>`;
      });
    },
    transUrl(text) {
      var regURL =
        /(?:(?:https?|ftp|file):\/\/|www\.|ftp\.)(?:\([-A-Z0-9+&@#/%=~_|$?!:,.]*\)|[-A-Z0-9+&@#/%=~_|$?!:,.])*(?:\([-A-Z0-9+&@#/%=~_|$?!:,.]*\)|[A-Z0-9+&@#/%=~_|$])/gim;
      return text.replace(regURL, function (url) {
        return `<a href="${url}" target='_blank'>${url}</a>`;
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
        let receivedAllMessage = result.data.result;
        if (receivedAllMessage.length == 50) {
          this.more = true;
        } else {
          this.more = false;
        }
        var array = [];
        for (var i = 0; i < receivedAllMessage.length; i++) {
          //시간을 한국 시간+디스코드에 맞게 변환
          if (
            receivedAllMessage[i].type != "typing" &&
            receivedAllMessage[i].type != "delete" &&
            receivedAllMessage[i].type != "connect" &&
            receivedAllMessage[i].type != "disconnect"
          ) {
            const translatedTime = convertFromStringToDate(
              receivedAllMessage[i].time
            );
            receivedAllMessage[i].date = translatedTime[0];
            receivedAllMessage[i].time = translatedTime[1];
            //연속된 메시지 처리(같은 유저의 메시지인지, 동일시간의 메시지인지 구분)
            let isOther = true;
            if (i != 0) {
              const timeResult = this.isSameTime(
                receivedAllMessage[i - 1],
                receivedAllMessage[i]
              );
              if (
                timeResult &&
                receivedAllMessage[i - 1].userId == receivedAllMessage[i].userId
              ) {
                isOther = false;
              }
            }
            receivedAllMessage[i].isOther = isOther;
            //초대장 관련
            if (
              receivedAllMessage[i].message &&
              receivedAllMessage[i].message.startsWith("<~inviting~>")
            ) {
              let callingMessage = receivedAllMessage[i].message.replace(
                "<~inviting~>",
                ""
              );
              receivedAllMessage[i].isInviteUrl = true;
              receivedAllMessage[i].message = this.transUrl(callingMessage);
            }
          }
          //이미지를 보낼시 이미지 처리
          if (
            receivedAllMessage[i].fileType &&
            receivedAllMessage[i].fileType == "image"
          ) {
            receivedAllMessage[i].thumbnail = this.urlify(
              receivedAllMessage[i].thumbnail
            );
          }
          //dm calling 메시지 받기
          if (
            receivedAllMessage[i].message &&
            receivedAllMessage[i].message.startsWith("<~dmcalling~>")
          ) {
            let callingMessage = receivedAllMessage[i].message.replace(
              "<~dmcalling~>",
              ""
            );
            receivedAllMessage[i].message = callingMessage;
            receivedAllMessage[i].calling = true;
            receivedAllMessage[i].isOther = true;
          }
          array.push(receivedAllMessage[i]);
        }
        let newarray = array.concat(this.receiveList);
        this.receiveList = newarray;

        if (this.page == 0) {
          await this.$nextTick(function () {
            this.scrollToBottom();
          });
          this.imageLoading = true;
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
  destroyed() {
    this.stompSocket.unsubscribe();
  },
};
</script>

<style>
.dm_call {
  width: 18px;
  height: 18px;
  background-image: url("../../assets/dm_call.svg");
}
.dm-avatar {
  pointer-events: auto;
  position: absolute;
  left: 32px;
  margin-top: calc(4px - 0.125rem);
  width: 18px;
  height: 18px;
  border-radius: 50%;
  overflow: hidden;
  cursor: pointer;
  user-select: none;
  -webkit-box-flex: 0;
  flex: 0 0 auto;
  z-index: 1;
}
</style>
