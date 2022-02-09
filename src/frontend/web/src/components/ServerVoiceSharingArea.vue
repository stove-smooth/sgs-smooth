<template>
  <div class="voice-participant-sharing">
    <div class="voice-participant-container">
      <div id="wrapper">
        <div>오잉{{ this.participants }}</div>
        <div class="wrap">
          <div class="scroll__wrap participant-scroller">
            <voice-participants
              v-for="voiceMember in voiceMembers"
              :key="voiceMember.name"
              :participant="voiceMember"
            ></voice-participants>
          </div>
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
  async created() {
    console.log("servervoicesharingarea 접근");
    //const rand_0_9 = Math.floor(Math.random() * 10);
    let message = {
      id: "joinRoom",
      token: this.getAccessToken,
      userId: this.getUserId,
      roomId: `c-${this.$route.params.channelid}`,
    };
    let voiceRoomInfo = {
      myName: this.getUserId,
      roomName: `c-${this.$route.params.channelid}`,
    };
    this.sendMessage(message);
    this.setVoiceInfo(voiceRoomInfo);
    console.log("message", message, "voiceRoomInfo", voiceRoomInfo);
    /* this.ws.onmessage = function (message) {
      console.log("일로안오나?");
      let parsedMessage = JSON.parse(message.data);
      console.log("Received message: " + message.data);
      this.onServerMessage(parsedMessage);
    }; */
  },

  computed: {
    ...mapGetters("user", ["getAccessToken", "getUserId"]),
    ...mapState("voice", ["participants", "ws", "mute", "video", "myName"]),
    ...mapState("server", ["currentChannelType", "communityInfo"]),
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
    ...mapActions("voice", [
      "setVoiceInfo",
      "sendMessage",
      "leaveRoom",
      "onServerMessage",
    ]),
    ...mapMutations("voice", ["setMute", "setVideo"]),
    toggleMic() {
      this.setMute();
      this.myParticipantObject.rtcPeer.audioEnabled = !this.mute;
    },
    toggleVideo() {
      this.myParticipantObject.rtcPeer.videoEnabled = !this.video;
      this.setVideo();
    },
    /* leaveChannel() {
      this.sendMessage({ id: "leaveRoom" });
      console.log("leaveRoom");
      this.leaveRoom();
    }, */
    leaveVoiceConnection() {
      this.sendMessage({ id: "leaveRoom" });
      console.log("leaveRoom");
      this.leaveRoom();
      if (this.currentChannelType != "TEXT") {
        //첫번째 채널 혹은 welcomepage로 이동.
        const categories = this.communityInfo.categories;
        for (var category in categories) {
          if (categories[category].channels != null) {
            for (var channels in categories[category].channels) {
              if (categories[category].channels[channels].type === "TEXT") {
                const firstchannel = categories[category].channels[channels].id;
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
.root-voice-sharing {
  height: 100%;
  width: 100%;
  position: relative;
  display: flex;
  -webkit-box-align: center;
  align-items: center;
  -webkit-box-pack: center;
  justify-content: center;
  color: #fff;
}
.voice-participant-sharing {
  flex: 1 1 0;
  display: flex;
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
  background-color: blanchedalmond;
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
  background-image: url("../assets/big-camera-disabled.svg");
}
.big-video-camera {
  display: flex;
  width: 40px;
  height: 40px;
  background-image: url("../assets/big-video-camera.svg");
}
.big-mute {
  display: flex;
  width: 40px;
  height: 40px;
  background-image: url("../assets/big-mute.svg");
}
.big-mute-on {
  display: flex;
  width: 40px;
  height: 40px;
  background-image: url("../assets/big-mute-on.svg");
}
.big-no-connect {
  display: flex;
  width: 40px;
  height: 40px;
  background-image: url("../assets/big-no-connect.svg");
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

/* 가로 스크롤 적용 */
.scroll__wrap {
  overflow-x: auto;
  white-space: nowrap;
  font-size: 0;
  display: flex;
  background-color: #202225;
}
.scroll--element {
  display: inline-block;
  width: 150px;
  height: 150px;
  border: 2px solid #222;
  background: #fff;
  font-size: 16px;
  line-height: 150px;
  text-align: center;
}
.scroll--element + .scroll--element {
  margin-left: 15px;
}

.participant-scroller::-webkit-scrollbar {
  width: 14px;
  height: 14px;
}
.participant-scroller::-webkit-scrollbar-corner {
  border: none;
  background: none;
}
.participant-scroller::-webkit-scrollbar-thumb {
  background-color: #5865f2;
  border-width: 3px;
  border-radius: 7px;
  background-clip: padding-box;
}
.participant-scroller::-webkit-scrollbar-track {
  border-width: initial;
  border-color: transparent;
  background-color: rgba(0, 0, 0, 0.1);
}
</style>
<style scoped>
body {
  font: 13px/20px "Lucida Grande", Tahoma, Verdana, sans-serif;
  color: #404040;
  background: #0ca3d2;
}

input[type="checkbox"],
input[type="radio"] {
  border: 1px solid #c0c0c0;
  margin: 0 0.1em 0 0;
  padding: 0;
  font-size: 16px;
  line-height: 1em;
  width: 1.25em;
  height: 1.25em;
  background: #fff;
  background: -webkit-gradient(
    linear,
    0% 0%,
    0% 100%,
    from(#ededed),
    to(#fbfbfb)
  );
  -webkit-appearance: none;
  -webkit-box-shadow: 1px 1px 1px #fff;
  -webkit-border-radius: 0.25em;
  vertical-align: text-top;
  display: inline-block;
}

input[type="radio"] {
  -webkit-border-radius: 2em; /* Make radios round */
}

input[type="checkbox"]:checked::after {
  content: "✔";
  display: block;
  text-align: center;
  font-size: 16px;
  height: 16px;
  line-height: 18px;
}

input[type="radio"]:checked::after {
  content: "●";
  display: block;
  height: 16px;
  line-height: 15px;
  font-size: 20px;
  text-align: center;
}

select {
  border: 1px solid #d0d0d0;
  background: url(http://www.quilor.com/i/select.png) no-repeat right center,
    -webkit-gradient(linear, 0% 0%, 0% 100%, from(#fbfbfb), to(#ededed));
  -webkit-box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
  -moz-box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
  -webkit-box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
  color: #444;
}

.container {
  margin: 50px auto;
  width: 640px;
  height: 500px;
}
.voice-participant-container {
  flex: 1 1 0;
}

.join {
  position: relative;
  margin: 0 auto;
  padding: 20px 20px 20px;
  width: 310px;
  background: white;
  border-radius: 3px;
  -webkit-box-shadow: 0 0 200px rgba(255, 255, 255, 0.5),
    0 1px 2px rgba(0, 0, 0, 0.3);
  box-shadow: 0 0 200px rgba(255, 255, 255, 0.5), 0 1px 2px rgba(0, 0, 0, 0.3);
  /*Transition*/
  -webkit-transition: all 0.3s linear;
  -moz-transition: all 0.3s linear;
  -o-transition: all 0.3s linear;
  transition: all 0.3s linear;
}

.join:before {
  content: "";
  position: absolute;
  top: -8px;
  right: -8px;
  bottom: -8px;
  left: -8px;
  z-index: -1;
  background: rgba(0, 0, 0, 0.08);
  border-radius: 4px;
}

.join h1 {
  margin: -20px -20px 21px;
  line-height: 40px;
  font-size: 15px;
  font-weight: bold;
  color: #555;
  text-align: center;
  text-shadow: 0 1px white;
  background: #f3f3f3;
  border-bottom: 1px solid #cfcfcf;
  border-radius: 3px 3px 0 0;
  -webkit-box-shadow: 0 1px whitesmoke;
  box-shadow: 0 1px whitesmoke;
}

.join p {
  margin: 20px 0 0;
}

.join p:first-child {
  margin-top: 0;
}

.join input[type="text"],
.join input[type="password"] {
  width: 278px;
}

.join p.submit {
  text-align: center;
}

:-moz-placeholder {
  color: #c9c9c9 !important;
  font-size: 13px;
}

::-webkit-input-placeholder {
  color: #ccc;
  font-size: 13px;
}

input {
  font-family: "Lucida Grande", Tahoma, Verdana, sans-serif;
  font-size: 14px;
}

input[type="text"],
input[type="password"] {
  margin: 5px;
  padding: 0 10px;
  width: 200px;
  height: 34px;
  color: #404040;
  background: white;
  border: 1px solid;
  border-color: #c4c4c4 #d1d1d1 #d4d4d4;
  border-radius: 2px;
  outline: 5px solid #eff4f7;
  -moz-outline-radius: 3px;
  -webkit-box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.12);
  box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.12);
}

input[type="text"]:focus,
input[type="password"]:focus {
  border-color: #7dc9e2;
  outline-color: #dceefc;
  outline-offset: 0;
}

input[type="button"],
input[type="submit"] {
  padding: 0 18px;
  height: 29px;
  font-size: 12px;
  font-weight: bold;
  color: #527881;
  text-shadow: 0 1px #e3f1f1;
  background: #cde5ef;
  border: 1px solid;
  border-color: #b4ccce #b3c0c8 #9eb9c2;
  border-radius: 16px;
  outline: 0;
  -webkit-box-sizing: content-box;
  -moz-box-sizing: content-box;
  box-sizing: content-box;
  background-image: -webkit-linear-gradient(top, #edf5f8, #cde5ef);
  background-image: -moz-linear-gradient(top, #edf5f8, #cde5ef);
  background-image: -o-linear-gradient(top, #edf5f8, #cde5ef);
  background-image: linear-gradient(to bottom, #edf5f8, #cde5ef);
  -webkit-box-shadow: inset 0 1px white, 0 1px 2px rgba(0, 0, 0, 0.15);
  box-shadow: inset 0 1px white, 0 1px 2px rgba(0, 0, 0, 0.15);
}

input[type="button"]:active,
input[type="submit"]:active {
  background: #cde5ef;
  border-color: #9eb9c2 #b3c0c8 #b4ccce;
  -webkit-box-shadow: inset 0 0 3px rgba(0, 0, 0, 0.2);
  box-shadow: inset 0 0 3px rgba(0, 0, 0, 0.2);
}

.lt-ie9 input[type="text"],
.lt-ie9 input[type="password"] {
  line-height: 34px;
}

#room {
  text-align: center;
  display: flex;
}

#button-leave {
  text-align: center;
  position: absolute;
  bottom: 10px;
}

.participant {
  border-radius: 4px;
  /* border: 2px groove; */
  text-align: center;
  float: left;
  padding: 5px;
  border-radius: 10px;
  -webkit-box-shadow: 0 0 200px rgba(255, 255, 255, 0.5),
    0 1px 2px rgba(0, 0, 0, 0.3);
  box-shadow: 0 0 200px rgba(255, 255, 255, 0.5), 0 1px 2px rgba(0, 0, 0, 0.3);
  /*Transition*/
  -webkit-transition: all 0.3s linear;
  -moz-transition: all 0.3s linear;
  -o-transition: all 0.3s linear;
  transition: all 0.3s linear;
}

.participant:before {
  content: "";
  position: absolute;
  top: -8px;
  right: -8px;
  bottom: -8px;
  left: -8px;
  z-index: -1;
  background: rgba(0, 0, 0, 0.08);
  border-radius: 4px;
}

.participant:hover {
  opacity: 1;
  background-color: #0a33b6;
  -webkit-transition: all 0.5s linear;
  transition: all 0.5s linear;
}

.participant video,
.participant.main video {
  width: 100% !important;
  height: auto !important;
}

.participant span {
  color: PapayaWhip;
}

.participant.main {
  width: 20%;
  margin: 0 auto;
}

.participant.main video {
  height: auto;
}

.animate {
  -webkit-animation-duration: 0.5s;
  -webkit-animation-fill-mode: both;
  -moz-animation-duration: 0.5s;
  -moz-animation-fill-mode: both;
  -o-animation-duration: 0.5s;
  -o-animation-fill-mode: both;
  -ms-animation-duration: 0.5s;
  -ms-animation-fill-mode: both;
  animation-duration: 0.5s;
  animation-fill-mode: both;
}

.removed {
  -webkit-animation: disapear 1s;
  -webkit-animation-fill-mode: forwards;
  animation: disapear 1s;
  animation-fill-mode: forwards;
}

a.hovertext {
  position: relative;
  width: 500px;
  text-decoration: none !important;
  text-align: center;
}

a.hovertext:after {
  content: attr(title);
  position: absolute;
  left: 0;
  bottom: 0;
  padding: 0.5em 20px;
  width: 460px;
  background: rgba(0, 0, 0, 0.8);
  text-decoration: none !important;
  color: #fff;
  opacity: 0;
  -webkit-transition: 0.5s;
  -moz-transition: 0.5s;
  -o-transition: 0.5s;
  -ms-transition: 0.5s;
}

a.hovertext:hover:after,
a.hovertext:focus:after {
  opacity: 1;
}
</style>
