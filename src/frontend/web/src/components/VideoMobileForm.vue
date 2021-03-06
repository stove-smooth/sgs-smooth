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
    <div class="voice-bottom-mobile-control-section">
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
import { mapActions, mapMutations, mapState, mapGetters } from "vuex";
import VoiceParticipants from "../components/common/Voice/VoiceParticipants.vue";
export default {
  components: { VoiceParticipants },
  data() {
    return {
      userId: this.$route.query.userId,
      accessToken: this.$route.query.token,
    };
  },
  created() {
    console.log("videoMobileForm created");
    //들어온 채널의 상태를 보냄.
    if (this.$route.params.serverid != 0) {
      //커뮤니티에 있을 경우
      //음성연결 입장 알림
      let message = {
        id: "joinRoom",
        token: this.accessToken,
        userId: this.userId,
        roomId: `c-${this.$route.params.channelid}`,
        communityId: this.$route.params.serverid,
        video: this.video,
        audio: !this.mute,
      };
      let voiceRoomInfo = {
        myName: this.userId,
        roomName: `c-${this.$route.params.channelid}`,
      };

      this.sendMessage(message);
      this.setVoiceInfo(voiceRoomInfo);
    } else {
      //DM에 있을 경우
      //음성연결 입장 알림
      let message = {
        id: "joinRoom",
        token: this.accessToken,
        userId: this.userId,
        roomId: `r-${this.$route.params.channelid}`,
        communityId: this.$route.params.serverid,
        video: this.video,
        audio: !this.mute,
      };
      let voiceRoomInfo = {
        myName: this.userId,
        roomName: `r-${this.$route.params.channelid}`,
      };

      this.sendMessage(message);
      this.setVoiceInfo(voiceRoomInfo);
    }
  },
  computed: {
    ...mapState("voice", ["participants", "mute", "video", "myName", "deafen"]),
    ...mapGetters("user", ["getUserId"]),
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
      return this.participants[this.userId];
    },
  },
  methods: {
    ...mapActions("voice", ["setVoiceInfo", "sendMessage", "leaveRoom"]),
    ...mapMutations("voice", ["setMute", "setVideo"]),
    toggleMic() {
      if (this.mute) {
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
      this.sendMessage({ id: "leaveRoom" });
      this.leaveRoom();
    },
  },
};
</script>
<style>
.voice-bottom-mobile-control-section {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  -webkit-box-align: center;
  align-items: center;
  -webkit-box-pack: justify;
  justify-content: center;
  line-height: 0;
  height: 80px;
  margin-bottom: 24px;
}
</style>
