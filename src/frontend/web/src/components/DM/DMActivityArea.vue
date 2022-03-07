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
import MessageActivityArea from "../common/Message/MessageActivityArea.vue"
import MessageInputArea from "../common/Message/MessageInputArea.vue"
import { mapState, mapMutations, mapGetters } from "vuex";
import { readDMChatMessage } from "../../api/index";
import { emojiClose, readMessageInarow, realMessageInarow } from '@/utils/chat.js';
export default {
  components: {
    MessageActivityArea,
    MessageInputArea
  },
  data() {
    return {
      text: "",
      receiveList: [],
      emojiPopout: false,
      editEmojiPopout: "",
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
    ...mapState("dm", ["directMessageMemberList"]),
    ...mapGetters("user", ["getUserId"]),
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
        /**메세지의 종류: 일반 채팅, 이미지 채팅, 수정, 삭제, 답장, 타이핑 상태  */
        //한국시간에 맞게 시간 커스텀
        const receivedForm = JSON.parse(res.body);
        if (
          receivedForm.type != "typing" &&
          receivedForm.type != "delete" &&
          receivedForm.type != "connect" &&
          receivedForm.type != "disconnect"
        ) {
          realMessageInarow(receivedForm,this.receiveList);
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
          receivedForm.thumbnail = this.transImg(receivedForm.thumbnail);
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
          console.log("connecttttttttt",this.directMessageMemberList)
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
     * text가 변경될 경우 , 6초에 텀을 두고 상태를 확인하고 서버에 다시 알릴지 결정한다.
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
          //6초가 지나지 않아 메세지 입력 상태를 보내지 않는다.
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
    ...mapMutations("community", ["setMessagePlusMenu"]),
    //메시지 추가 기능을 위한 마우스 좌표
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
    transUrl(text) {
      var regURL =
        /(?:(?:https?|ftp|file):\/\/|www\.|ftp\.)(?:\([-A-Z0-9+&@#/%=~_|$?!:,.]*\)|[-A-Z0-9+&@#/%=~_|$?!:,.])*(?:\([-A-Z0-9+&@#/%=~_|$?!:,.]*\)|[A-Z0-9+&@#/%=~_|$])/gim;
      return text.replace(regURL, function (url) {
        return `<a class="sky-blue-color" href="${url}" target='_blank'>${url}</a>`;
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
            readMessageInarow(receivedAllMessage,i);
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
            receivedAllMessage[i].thumbnail = this.transImg(
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
.sky-blue-color {
  color: #00aff4;
}
</style>
