<template>
  <div class="server-chatting-container">
    <div
      class="thin-scrollbar server-chat-scroller"
      ref="scrollRef"
      @scroll="handleScroll"
    >
      <message-activity-area 
        :imageLoading="this.imageLoading"
        :receiveList="this.receiveList" 
        :emojiPopout="this.emojiPopout" 
        :editEmojiPopout="this.editEmojiPopout"
        @update-receive-list="updateReceiveList"
        @edit-list-with-emoji="editListWithEmoji"
        @select-text-with-emoji="selectTextWithEmoji"
        @update-emoji-popout="updateEditEmojiPopout"
      ></message-activity-area>
    </div>
    <message-input-area
      :text="this.text"
      :messageTyper="this.messageTyper"
      :emojiPopout="this.emojiPopout"
      @update-input-text="updateInputText"
      @open-emoji-popout="openEmojiPopout"
    ></message-input-area>
  </div>
</template>

<script>
import MessageActivityArea from "../../common/Message/MessageActivityArea.vue";
import MessageInputArea from "../../common/Message/MessageInputArea.vue";
import { emojiClose, realMessageInarow, readMessageInarow} from "@/utils/chat";
import { mapState, mapMutations, mapGetters } from "vuex";
import {readChatMessage } from "../../../api/index";
export default {
  components: {
    MessageActivityArea,
    MessageInputArea,
  },
  data() {
    return {
      text: "",
      receiveList: [],
      emojiPopout: false,
      editEmojiPopout: false,
      page: 0,
      more: false,
      prevScrollHeight: 0,
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
    ...mapState("user", ["nickname"]),
    ...mapState("utils", ["stompSocketClient"]),
    ...mapState("community", ["messagePlusMenu"]),
    ...mapGetters("user", ["getUserId"]),
  },
  async created() {
    //들어온 채널의 상태를 보냄.
    const msg = {
      user_id: this.getUserId,
      channel_id: `c-${this.$route.params.channelid}`,
      type: "state",
    };
    this.stompSocketClient.send("/kafka/join-channel", JSON.stringify(msg), {});
    //최신 50개 메시지 기록 읽음
    await this.readChannelMessage();

    //실시간 메시지 구독
    this.stompSocket = this.stompSocketClient.subscribe(
      "/topic/group/" + this.$route.params.channelid,
      async (res) => {
        /**메세지의 종류: 일반 채팅, 이미지 채팅, 수정, 삭제, 답장, 타이핑 상태  */
        //한국시간에 맞게 시간 커스텀, 동일인물의 연속된 메세지 처리
        const receivedForm = JSON.parse(res.body);
        if (
          receivedForm.type != "typing" &&
          receivedForm.type != "delete"
        ) {
          realMessageInarow(receivedForm,this.receiveList);
        }
        //이미지를 보낼시 이미지 처리
        if (receivedForm.fileType && receivedForm.fileType == "image") {
          receivedForm.thumbnail = this.transImg(receivedForm.thumbnail);
        }
        //메세지 타입이 충족되는 경우 모두 메시지 리스트에 넣고, 렌더링이 된다면 스크롤을 바닥으로 내림
        if (
          receivedForm.type != "typing" &&
          receivedForm.type != "modify" &&
          receivedForm.type != "delete"
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
      }
    );
  },

  watch: {
    /**메세지 타이핑 상태를 서버에 알리기 위한 로직
     * text가 변경될 경우 , 6초에 텀을 두고 상태를 확인하고 서버에 다시 알릴지 결정한다.
     */
    text() {
      if (this.recentChatted) {
        //채팅한 기록이 있을 경우
        if (new Date() - this.recentChatted >= 6000) {
          this.recentChatted = new Date();
          const msg = {
            content: this.nickname,
            channelId: this.$route.params.channelid,
            type: "typing",
          };
          this.stompSocketClient.send(
            "/kafka/send-channel-typing",
            JSON.stringify(msg),
            {}
          );
        } else {
          // 6초가 지나지 않아 메세지 입력 상태를 보내지 않는다.
        }
      } else {
        //최근에 채팅한 적이 없을 경우
        this.recentChatted = new Date();
        const msg = {
          content: this.nickname,
          channelId: this.$route.params.channelid,
          type: "typing",
        };
        this.stompSocketClient.send(
          "/kafka/send-channel-typing",
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
    ...mapMutations("community", ["setMessagePlusMenu"]),
    onClick(e) {
      //메시지 플러스 메뉴가 등장한 상태에서 다른 영역을 클릭하면 메시지 플러스 메뉴는 꺼진다.
      if (this.messagePlusMenu != null) {
        if (!e.target.parentNode.dataset.key) {
          this.setMessagePlusMenu(null);
        }
      }
      //이미지 팝아웃이 등장한 상태에서 다른 영역을 클릭하면 팝아웃은 꺼진다.
      if(this.emojiPopout||this.editEmojiPopout){
        if (emojiClose(e)) {
          this.emojiPopout = false;
          this.editEmojiPopout = false;
        }
      } 
    },
    transImg(text) {
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
        const result = await readChatMessage(
          this.$route.params.channelid,
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
            receivedAllMessage[i].type != "delete"
          ) {
            readMessageInarow(receivedAllMessage,i);
          }
          //이미지를 보낼시 이미지 처리
          if (
            receivedAllMessage[i].fileType &&
            receivedAllMessage[i].fileType == "image"
          ) {
            receivedAllMessage[i].thumbnail = this.transImg(
              receivedAllMessage[i].thumbnail
            );
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
    updateReceiveList(array){
      this.receiveList = array;
    },
    editListWithEmoji(i,data){
      this.receiveList[i].message += data;
    },
    selectTextWithEmoji(data){
      this.text += data;
    },
    updateEditEmojiPopout(data){
      this.editEmojiPopout = data;
    },
    updateInputText(updatedText){
      this.text = updatedText;
    },
    openEmojiPopout() {
      this.emojiPopout = !this.emojiPopout;
    },
  },
  beforeDestroy(){
    window.removeEventListener("click", this.onClick);
  },
  destroyed() {
    this.stompSocket.unsubscribe();
  },
};
</script>

<style>
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
.server-chat-scroller {
  overflow: hidden scroll;
  padding-right: 0px;
  width: 100%;
  flex: 1;
  align-items: flex-end;
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
  background-image: url("../../../assets/trashcan.svg");
}
.add-emotion {
  width: 24px;
  height: 24px;
  background-image: url("../../../assets/add-emotion.svg");
}
.edit-pencil {
  width: 24px;
  height: 24px;
  background-image: url("../../../assets/edit-pencil.svg");
}
.row-plus-action {
  width: 20px;
  height: 20px;
  background-image: url("../../../assets/row-plus-action.svg");
}
.selected-message-area {
  background-color: #2f3136;
}
.message-reply-content {
  display: flex;
  flex-direction: row;
  color: var(--discord-primary);
}
.reply-accessories {
  width: 5px;
  height: 1px;
  border-left: 1mm solid var(--discord-primary);
  border-top: 1mm solid var(--discord-primary);
  margin-right: 7px;
}
.message-replying {
  position: relative;
  background-color: rgba(53, 68, 129, 0.1);
  border-left: 1mm solid var(--discord-primary);
}
.reply-button {
  width: 20px;
  height: 20px;
  background-image: url("../../../assets/reply-button.svg");
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
  background-image: url("../../../assets/yellow-emotion.svg");
}
</style>
