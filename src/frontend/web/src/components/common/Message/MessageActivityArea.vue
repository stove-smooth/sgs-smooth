<template>
  <div>
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
                  'margin-top-8px': item.calling,
                  'message-replying':
                    (communityMessageReplyId !== '' &&
                    communityMessageReplyId.messageInfo.id == item.id)||
                    (directMessageReplyId !== '' &&
                    directMessageReplyId.messageInfo.id == item.id),
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
                  <div v-else class="message-content">
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
                    v-if="messageReadyToDelete == item.id||directMessageReadyToDelete == item.id"
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
</template>

<script>
import { VEmojiPicker } from "v-emoji-picker";
import { mapState,mapMutations,mapGetters } from "vuex";
import { clickPlusAction } from '@/utils/chat';
export default {
  components: {
    VEmojiPicker,
  },
  props:["imageLoading","receiveList","emojiPopout","editEmojiPopout"],
  data() {
    return {
      messageHovered: "",
      modifyLogMessage:"",
    }
  },
  computed:{
    ...mapState("community", [
      "messagePlusMenu",
      "communityMessageReplyId",
      "messageEditId",
      "messageReadyToDelete",
    ]),
    ...mapState("dm", [
      "directMessageReplyId",
      "directMessageReadyToDelete",
    ]),
    ...mapState("utils", ["stompSocketClient", "stompSocketConnected"]),
    ...mapGetters("user", ["getUserId"]),
  },
  methods:{
    ...mapMutations("community", [
      "setCommunityMessageReplyId",
      "setMessageReadyToDelete",
      "setMessageEditId",
    ]),
    ...mapMutations("dm", [
      "setDirectMessageReplyId",
      "setDirectMessageReadyToDelete",
    ]),
    messageHover(idx) {
      this.messageHovered = idx;
    },
    MessageReply(messagePlusMenu) {
      if(this.$route.params.channelid){
        const message = {
          channel: this.$route.params.channelid,
          messageInfo: messagePlusMenu,
        };
        this.setCommunityMessageReplyId(message);
      }else{
        const message = {
          channel: this.$route.params.id,
          messageInfo: messagePlusMenu,
        };
        this.setDirectMessageReplyId(message);
      }
    },
    cancelDelete() {
      if(this.$route.params.channelid){
        this.setMessageReadyToDelete(false);
      }else{
        this.setDirectMessageReadyToDelete(false);
      }
    },
    cancelModify() {
      this.setMessageEditId("");
      this.modifyLogMessage = "";
    },
    modify(id, content) {
      this.modifyLogMessage = "";
      if (this.stompSocketClient && this.stompSocketConnected) {
        if (content.trim().length == 0) {
          this.modifyLogMessage = "내용을 입력한 후 수정해주세요.";
        }
        if(this.$route.params.channelid){
          const msg = {
            id: id,
            content: content,
            userId: this.getUserId,
            channelId: this.$route.params.channelid,
            type: "modify",
          };
          this.stompSocketClient.send(
            "/kafka/send-channel-modify",
            JSON.stringify(msg),
            {}
          );
        }else{
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
        }
        this.setMessageEditId("");
      }
    },
    deleteMessage(id) {
      if(this.$route.params.channelid){
        const msg = {
          id: id,
          userId: this.getUserId,
          type: "delete",
          channelId: this.$route.params.channelid,
        };
        this.stompSocketClient.send(
          "/kafka/send-channel-delete",
          JSON.stringify(msg),
          {}
        );
        let array = this.receiveList.filter((element) => element.id !== id);
        this.$emit("update-receive-list",array);
        this.setMessageReadyToDelete(false);
      }else{
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
        this.$emit("update-receive-list",array);
        this.setDirectMessageReadyToDelete(false);
      }
    },
    //메시지 추가 기능을 위한 마우스 좌표
    clickPlusAction(event, messageInfo) {
      clickPlusAction(event,messageInfo)
    },
    onSelectEmoji(emoji) {
      this.$emit("select-text-with-emoji",emoji.data)
    },
    onSelectEditEmoji(emoji) {
      for (var i = 0; i < this.receiveList.length; i++) {
        if (this.receiveList[i].id == this.editEmojiPopout) {
          this.$emit("edit-list-with-emoji",i,emoji.data)
          break;
        }
      }
    },
    openEditEmojiPopout(messageId) {
      if (this.editEmojiPopout) {
        this.$emit("update-emoji-popout",false);
      } else {
        this.$emit("update-emoji-popout",messageId);
      }
    },
  }
}
</script>

<style>
.dm_call {
  width: 18px;
  height: 18px;
  background-image: url("../../../assets/dm_call.svg");
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
/**스켈레톤이미지 */
.loading-img {
  width: 355px;
  height: 355px;
  background-color: #e0e0e0;
}
/**메세지 수정 */
.channel-message-edit-area {
  position: relative;
  width: 100%;
  text-indent: 0;
  border-radius: 8px;
  margin-top: 8px;
  background-color: #40444b;
  display: flex;
}
.channel-message-edit-tool-area {
  padding: 7px 0;
  font-size: 12px;
  font-weight: 400;
  text-indent: 0;
  color: #dcddde;
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
.message-date-divider {
  margin-top: 1.5rem;
  margin-bottom: 0.5rem;
  position: relative;
  left: auto;
  right: auto;
  z-index: 1;
  height: 0;
  border-top: thin solid hsla(0, 0%, 100%, 0.06);
  display: flex;
  -webkit-box-align: center;
  align-items: center;
  -webkit-box-pack: center;
  justify-content: center;
  -webkit-box-flex: 0;
  flex: 0 0 auto;
  pointer-events: none;
  box-sizing: border-box;
  --divider-color: hsl(359, calc(var(1, 1) * 82.6%), 59.4%);
  margin-left: 1rem;
  margin-right: 0.875rem;
}
.date-content {
  display: block;
  -webkit-box-flex: 0;
  flex: 0 0 auto;
  padding: 2px 4px;
  color: #72767d;
  background: #36393f;
  line-height: 13px;
  font-size: 12px;
  margin-top: -1px;
  font-weight: 600;
  border-radius: 8px;
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
.chat-message-wrapper {
  outline: none;
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

</style>