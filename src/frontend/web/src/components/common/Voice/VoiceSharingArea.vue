<template>
  <div class="voice-participant-sharing">
    <div
      class="voice-participant-container"
      v-if="voiceMembers"
      v-bind:class="{
        'two-participant-container': voiceMembers.length <= 2,
        'four-participant-container':
          voiceMembers.length > 2 && voiceMembers.length <= 4,
        'more-than-participant-container': voiceMembers.length > 4,
      }"
    >
      <div
        class="voice-participant-wrapper"
        v-for="voiceMember in voiceMembers"
        :key="voiceMember.name"
      >
        <div
          class="align-items-center justify-content-center"
          :key="voiceMember.videoStatus"
        >
          <voice-participants
            :participant="voiceMember"
            :key="voiceMember.audioStatus"
          ></voice-participants>
        </div>
      </div>
    </div>
    <div class="voice-bottom-control-section">
      <div class="voice-bottom-control-container">
        <div
          class="voice-control-button justify-content-center align-items-center clickable"
          @click="toggleVideo"
        >
          <div v-if="video" class="big-video-camera"></div>
          <div v-else class="big-camera-disabled"></div>
        </div>
        <div
          class="voice-control-button justify-content-center align-items-center clickable"
          @click="toggleMic"
        >
          <div v-if="!mute" class="big-mute"></div>
          <div v-else class="big-mute-on"></div>
        </div>
        <div
          class="voice-control-button justify-content-center align-items-center red-voice-control-button clickable"
          @click="leaveVoiceConnection"
        >
          <div class="big-no-connect"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions, mapMutations, mapState } from "vuex";
import VoiceParticipants from "./VoiceParticipants.vue";
export default {
  components: { VoiceParticipants },
  created() {
    //들어온 채널의 상태를 보냄.
    if (this.$route.params.channelid) {
      //커뮤니티에 있을 경우
      //음성연결 입장 알림
      const msg = {
        user_id: this.getUserId,
        channel_id: `c-${this.$route.params.channelid}`,
        community_id: this.$route.params.serverid,
        type: "enter",
      };
      this.stompSocketClient.send("/kafka/signaling", JSON.stringify(msg), {});

      let message = {
        id: "joinRoom",
        token: this.getAccessToken,
        userId: this.getUserId,
        roomId: `c-${this.$route.params.channelid}`,
        communityId: this.$route.params.serverid,
        video: this.video,
        audio: !this.mute,
      };
      let voiceRoomInfo = {
        myName: this.getUserId,
        roomName: `c-${this.$route.params.channelid}`,
      };
      const currentVoiceRoomInfo = {
        type: "community",
        name: this.communityInfo.name,
      };
      this.setCurrentVoiceRoom(currentVoiceRoomInfo);
      this.sendMessage(message);
      this.setVoiceInfo(voiceRoomInfo);
    } else {
      //DM에 있을 경우
      //음성연결 입장 알림
      let message = {
        id: "joinRoom",
        token: this.getAccessToken,
        userId: this.getUserId,
        roomId: `r-${this.$route.params.id}`,
        communityId: 0,
        video: this.video,
        audio: !this.mute,
      };
      let voiceRoomInfo = {
        myName: this.getUserId,
        roomName: `r-${this.$route.params.id}`,
      };
      const currentVoiceRoomInfo = {
        type: "room",
        name: this.directMessageMemberList.name,
      };
      this.setCurrentVoiceRoom(currentVoiceRoomInfo);
      this.sendMessage(message);
      this.setVoiceInfo(voiceRoomInfo);
    }
  },
  computed: {
    ...mapGetters("user", ["getAccessToken", "getUserId"]),
    ...mapState("voice", [
      "participants",
      "ws",
      "mute",
      "video",
      "myName",
      "deafen",
    ]),
    ...mapState("community", ["currentChannelType", "communityInfo"]),
    ...mapState("dm", ["directMessageMemberList"]),
    ...mapState("utils", ["stompSocketClient"]),
    voiceMembers() {
      //참여자 감지
      if (this.participants) {
        var participantList = [];
        Object.keys(this.participants).forEach((key) => {
          participantList.push(this.participants[key]);
        });
        return participantList;
      } else {
        return null;
      }
    },
    myParticipantObject() {
      return this.participants[this.myName];
    },
  },
  methods: {
    ...mapActions("voice", ["setVoiceInfo", "sendMessage", "leaveRoom"]),
    ...mapMutations("voice", ["setMute", "setVideo", "setCurrentVoiceRoom"]),
    toggleMic() {
      if (this.mute) {
        //음소거 되어있을경우. 음소거 안되게 만들어야함.
        this.sendMessage({
          id: "audioStateFrom",
          userId: this.getUserId,
          audio: "true",
        });
      } else {
        this.sendMessage({
          id: "audioStateFrom",
          userId: this.getUserId,
          audio: "false",
        });
      }
      this.myParticipantObject.rtcPeer.audioEnabled = this.mute;
      this.setMute();
    },
    toggleVideo() {
      //다른 참여자의 비디오 상태를 알기 위한 로직
      if (this.video) {
        this.sendMessage({
          id: "videoStateFrom",
          userId: this.getUserId,
          video: "false",
        });
      } else {
        this.sendMessage({
          id: "videoStateFrom",
          userId: this.getUserId,
          video: "true",
        });
      }
      this.myParticipantObject.rtcPeer.videoEnabled = !this.video;
      this.setVideo();
    },
    //webRTC 연결을 끊을 시 서버내 다른 채팅 채널로 이동해야함
    leaveVoiceConnection() {
      if (this.$route.params.channelid) {
        this.sendMessage({ id: "leaveRoom" });
        console.log("leaveRoom");
        this.leaveRoom();
        this.setCurrentVoiceRoom(null);
        if (this.currentChannelType != "TEXT") {
          //첫번째 채널 혹은 welcomepage로 이동.
          const categories = this.communityInfo.categories;
          for (var category in categories) {
            if (categories[category].channels != null) {
              for (var channels in categories[category].channels) {
                if (categories[category].channels[channels].type === "TEXT") {
                  const firstchannel =
                    categories[category].channels[channels].id;
                  this.$router.push(
                    "/channels/" +
                      this.$route.params.serverid +
                      "/" +
                      firstchannel
                  );
                  return;
                }
              }
            }
          }
          this.$router.push("/channels/" + this.$route.params.serverid);
        }
      } else {
        this.sendMessage({ id: "leaveRoom" });
        console.log("leaveRoom");
        this.leaveRoom();
        this.setCurrentVoiceRoom(null);
      }
    },
  },
};
</script>

<style>
.voice-sharing-container {
  display: flex;
  position: relative;
  -webkit-box-flex: 0;
  flex: 1 1 auto;
  background-color: #000;
  z-index: 2;
}
.voice-participant-sharing {
  position: relative;
  display: flex;
  width: 100%;
  height: 100%;
  flex-direction: column;
}
.voice-bottom-control-section {
  display: flex;
  -webkit-box-align: center;
  align-items: center;
  -webkit-box-pack: justify;
  justify-content: center;
  line-height: 0;
  height: 80px;
  margin-bottom: 24px;
}
.voice-bottom-control-container {
  display: flex;
  align-items: center;
}
.voice-control-button {
  width: 70px;
  height: 70px;
  border-radius: 50%;
  display: flex;
  background-color: #000;
  margin: 12px;
}
.red-voice-control-button {
  background-color: #ed4245;
}
.big-camera-disabled {
  display: flex;
  width: 40px;
  height: 40px;
  background-image: url("../../../assets/big-camera-disabled.svg");
}
.big-video-camera {
  display: flex;
  width: 40px;
  height: 40px;
  background-image: url("../../../assets/big-video-camera.svg");
}
.big-mute {
  display: flex;
  width: 40px;
  height: 40px;
  background-image: url("../../../assets/big-mute.svg");
}
.big-mute-on {
  display: flex;
  width: 40px;
  height: 40px;
  background-image: url("../../../assets/big-mute-on.svg");
}
.big-no-connect {
  display: flex;
  width: 40px;
  height: 40px;
  background-image: url("../../../assets/big-no-connect.svg");
}
.voice-participant-sharing-area {
  width: 100px;
  height: 100px;
  background-color: lawngreen;
}
/* 기본 구조 */
.wrap {
  max-width: 500px;
  margin: 50px auto;
  background: #f8f8f8;
}
</style>
<style scoped>
.voice-participant-container {
  margin: 0px auto;
  display: grid;
  width: 90%;
  height: 90%;
  -webkit-box-pack: center;
  justify-content: center;
  -webkit-box-align: center;
  align-items: center;
  gap: 20px;
  padding: 20px;
}
.two-participant-container {
  grid-template-rows: 100%;
  max-width: 900px;
  grid-template-columns: repeat(auto-fit, minmax(45%, 1fr));
}
.four-participant-container {
  grid-template-rows: 50% 50%;
  max-width: 900px;
  grid-template-columns: repeat(auto-fit, minmax(45%, 1fr));
}
.more-than-participant-container {
  grid-template-rows: 50% 50%;
  max-width: 1500px;
  grid-template-columns: repeat(auto-fit, minmax(30%, 1fr));
}
.voice-participant-wrapper {
  flex: 1 1 0;
  justify-content: center;
  align-items: center;
  display: flex;
}
</style>
