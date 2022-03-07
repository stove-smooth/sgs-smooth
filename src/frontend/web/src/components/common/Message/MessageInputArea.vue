<template>
  <div class="channel-message-input-form">
    <div class="channel-message-area">
      <div
        class="attached-bar"
        v-if="
          (communityMessageReplyId !== '' &&
          communityMessageReplyId.channel == this.$route.params.channelid)||
          (directMessageReplyId !== '' &&
            directMessageReplyId.channel == this.$route.params.id)
        "
      >
        <div>
          <div class="clip-container">
            <div class="base-container">
              <div class="reply-bar">
                <div role="button" tabindex="0">
                  <div class="reply-label-container">
                    <span class="large-description">
                      {{ this.$route.params.channelid? communityMessageReplyId.messageInfo.name : directMessageReplyId.messageInfo.name}}
                    </span>
                    님에게 답장하는 중
                  </div>
                </div>
                <div class="align-items-center">
                  <template v-if="this.$route.params.channelid">
                    <div
                      class="reply-close-button"
                      @click="setCommunityMessageReplyId('')"
                    >
                      <svg class="small-close-button"></svg>
                    </div>
                  </template>
                  <template v-else>
                    <div
                      class="reply-close-button"
                      @click="setDirectMessageReplyId('')"
                    >
                      <svg class="small-close-button"></svg>
                    </div>
                  </template>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="channel-message-scrollbar-container">
        <div v-if="thumbnails.length > 0">
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
              v-model="updateText"
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

</template>

<script>
import { mapState, mapGetters, mapMutations} from "vuex";
import { sendImageChatting,sendImageDirectChatting } from '@/api/index';
import { converToThumbnail, dataUrlToFile } from "@/utils/common.js";
export default {
  props:["text","messageTyper","emojiPopout"],
  data() {
    return {
      images: [],
      thumbnails: [],
      thumbnailFiles: [],
    }
  },
  computed:{
     ...mapState("user", ["nickname", "userimage"]),
     ...mapGetters("user", ["getUserId"]),
     ...mapState("utils", ["stompSocketClient", "stompSocketConnected"]),
     ...mapState("community", ["communityMessageReplyId"]),
     ...mapState("dm", [
      "directMessageList",
      "directMessageReplyId",
    ]),
    updateText:{
      get () { return this.text },
      set (value) { this.$emit('update-input-text', value) },
    },
  },
  methods:{
    ...mapMutations("community", [
      "setCommunityMessageReplyId",
    ]),
    ...mapMutations("dm", [
      "setDirectMessageReplyId",
    ]),
    
    //메시지를 보낸 후 메시지를 초기화한다.
    initialMessage(e) {
      if (e.keyCode == 13 && !e.shiftKey && this.stompSocketConnected) {
        this.$emit("update-input-text","");
      }
    },
    sendMessage(e) {
      //enter시 메시지를 보낸다.
      if (e.keyCode == 13 && !e.shiftKey && this.stompSocketConnected) {
        //단, 텍스트 내용이 모두 스페이스 혹은 엔터로만 이루어져있다면 메시지를 보내지 않는다.
        if (this.text.trim().length == 0 && this.images.length == 0) {
          return;
        }
        //답장/일반메시지/사진메시지를 구분한다.
        if (this.communityMessageReplyId) {
          this.reply();
          return;
        }
        if (this.images.length > 0) {
          this.sendPicture();
        }
        if (this.text) {
          this.send();
        }
        if(this.$route.params.id&&this.directMessageList&&this.directMessageList[0].id != this.$route.params.id){
          for (let i = 0; i < this.directMessageList.length; i++) {
            if (this.directMessageList[i].id == this.$route.params.id) {
              let dmUpdated = this.directMessageList.splice(i, 1);
              this.directMessageList.unshift(dmUpdated[0]);
              return;
            }
          }
        }
      }
    },
    async sendPicture() {
      if(this.$route.params.channelid){
        const formData = new FormData();
        formData.append("image", this.images[0]);
        formData.append("thumbnail", this.thumbnailFiles[0]);
        formData.append("userId", this.getUserId);
        formData.append("channelId", this.$route.params.channelid);
        formData.append("communityId", this.$route.params.serverid);
        formData.append("type", "community");
        formData.append("fileType", "image");
        formData.append("name", this.nickname);
        formData.append("profileImage", this.userimage);
        try {
          await sendImageChatting(formData);
          this.images = [];
          this.thumbnails = [];
        } catch (err) {
          console.log("errrr", err.response);
        }
      }else{
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
      }
      
    },
    send() {
      if(this.$route.params.channelid){
        const msg = {
          content: this.text,
          communityId: this.$route.params.serverid,
          channelId: this.$route.params.channelid,
          userId: this.getUserId,
          name: this.nickname,
          profileImage: this.userimage,
        };
        this.stompSocketClient.send(
          "/kafka/send-channel-message",
          JSON.stringify(msg),
          {}
        );
      }else{
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
      if(this.$route.params.channelid){
        const msg = {
          content: this.text,
          communityId: this.$route.params.serverid,
          channelId: this.$route.params.channelid,
          userId: this.getUserId,
          name: this.nickname,
          profileImage: this.userimage,
          parentId: this.communityMessageReplyId.messageInfo.id,
          parentName: this.communityMessageReplyId.messageInfo.name,
          parentContent: this.communityMessageReplyId.messageInfo.message,
          type: "reply",
        };
        this.stompSocketClient.send(
          "/kafka/send-channel-reply",
          JSON.stringify(msg),
          {}
        );
        this.setCommunityMessageReplyId("");
      }else{
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
    openEmojiPopout(){
      this.$emit("open-emoji-popout");
    }
  }
}
</script>

<style scoped>
.channel-message-input-form {
  position: relative;
  flex-shrink: 0;
  padding-left: 16px;
  padding-right: 16px;
}
.channel-message-area {
  margin-bottom: 12px;
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
.message-attach-button {
  height: 44px;
  padding: 10px 16px;
  position: sticky;
  top: 0;
  cursor: pointer;
  margin: 0px 0px 0px -16px;
  width: auto;
  background: transparent;
  border: 0;
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
  background-image: url("../../../assets/attach-button.svg");
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
  background-image: url("../../../assets/small-close-button.svg");
}
.chatting-state {
  font-size: 12px;
  font-weight: 600;
  text-indent: 0;
  color: #dcddde;
  margin-left: 60px;
  margin-top: 6px;
}
.no-chatting-state-area {
  height: 22px;
}
</style>