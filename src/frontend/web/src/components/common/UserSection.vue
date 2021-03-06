<template>
  <div>
    <section class="my-section">
      <div class="primary-container" v-if="wsOpen">
        <div class="media-connected-container">
          <div class="display-flex">
            <div class="media-connected-title-inner">
              <div class="rtc-connection-status">
                <svg class="ping"></svg>
                <div class="rtc-connection-description">영상 연결됨</div>
              </div>
              <div class="subtext" v-if="currentVoiceRoom">
                {{ currentVoiceRoom.name }}
              </div>
            </div>
            <div
              class="device-controll-wrapper"
              @click="leaveVoiceConnection()"
            >
              <button
                class="device-controll-button"
                aria-label="연결끊기"
                type="button"
              >
                <svg class="no-connect"></svg>
              </button>
            </div>
          </div>
        </div>
      </div>
      <div class="my-section-container">
        <div
          class="margin-right-8px"
          aria-controls="popout"
          aria-expaned="true"
          aria-lable="상태설정"
          role="button"
        >
          <div class="profile-wrapper" aria-label="내 프로필">
            <div class="avatar-wrapper">
              <img class="avatar" :src="userimage" alt=" " />
              <template aria-label="status-invisible">
                <div class="status-ring">
                  <div class="status-online"></div>
                </div>
              </template>
            </div>
          </div>
        </div>
        <div class="nametag" role="button" tabindex="0">
          <div class="myname-container">
            <div class="myname">{{ nickname }}</div>
          </div>
          <div class="mycode">#{{ code }}</div>
        </div>
        <div class="mydevice-controller">
          <button
            class="device-controll-button"
            aria-label="마이크"
            role="switch"
            type="button"
            @click="toggleMic"
          >
            <svg v-if="mute" class="mute-on"></svg>
            <svg v-else class="mute"></svg>
          </button>
        </div>
        <div class="mydevice-controller">
          <button
            class="device-controll-button"
            aria-label="헤드셋"
            role="switch"
            type="button"
            @click="toggleHeadPhone"
          >
            <svg v-if="deafen" class="deafen-on"></svg>
            <svg v-else class="deafen"></svg>
          </button>
        </div>
        <div class="mydevice-controller">
          <button
            class="device-controll-button"
            aria-label="사용자 설정"
            role="switch"
            type="button"
            @click="openSettings"
          >
            <svg class="settings"></svg>
          </button>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
import { mapState, mapGetters, mapMutations, mapActions } from "vuex";
export default {
  methods: {
    ...mapMutations("voice", [
      "setMute",
      "setDeafen",
      "setVideo",
      "setCurrentVoiceRoom",
    ]),
    ...mapActions("user", ["fetchMyInfo"]),
    ...mapActions("voice", ["sendMessage", "leaveRoom"]),
    openSettings() {
      this.$router.push("/settings");
    },
    leaveVoiceConnection() {
      this.sendMessage({ id: "leaveRoom" });
      this.leaveRoom();
      this.setCurrentVoiceRoom(null);
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
    toggleMic() {
      //음성 연결에 참여했을 경우, 내 mic를 조절한다.
      //음성 연결에 참여하지 않았을 경우, mic상태만 변경한다.
      if (this.wsOpen) {
        this.myParticipantObject.rtcPeer.audioEnabled = this.mute;
      }
      this.setMute();
    },
    toggleHeadPhone() {
      //음성 연결에 참여했을 경우, 다른 참가자들의 비디오를 음소거한다. 혹은 음소거를 해제한다.
      //음성 연결에 참여하지 않았을 경우, 상태만 변경한다.
      if (this.wsOpen) {
        Object.keys(this.participants).forEach((key) => {
          let videoElement = this.participants[key].getVideoElement();
          if (key != this.getUserId) {
            videoElement.muted = !this.deafen;
          }
        });
      }

      this.setDeafen();
    },
  },
  computed: {
    ...mapGetters("user", ["getUserId"]),
    ...mapState("user", ["code", "nickname", "userimage"]),
    ...mapState("community", ["currentChannelType", "communityInfo"]),
    ...mapState("voice", [
      "wsOpen",
      "mute",
      "deafen",
      //"video",
      "myName",
      "participants",
      "currentVoiceRoom",
    ]),
    myParticipantObject() {
      return this.participants[this.myName];
    },
  },
  async created() {
    await this.fetchMyInfo();
  },
};
</script>

<style>
.media-connected-container {
  color: #fff;
  font-size: 14px;
  font-weight: 500;
  padding: 8px;
  -ms-flex-negative: 0;
  flex-shrink: 0;
  border-bottom: 1px solid hsla(0, 0%, 100%, 0.06);
}

.media-action-button {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(0, 1fr));
  grid-gap: 8px;
  padding-top: 4px;
  -webkit-box-pack: justify;
  -ms-flex-pack: justify;
  justify-content: space-between;
}
.media-connected-title-inner {
  flex: 1;
}
.rtc-connection-status {
  display: flex;
  -webkit-box-align: center;
  align-items: center;
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
  padding-bottom: 2px;
}
.no-connect {
  width: 20px;
  height: 20px;
  background-image: url("../../assets/no-connect.svg");
}
.ping {
  width: 16px;
  height: 16px;
  background-image: url("../../assets/ping.svg");
}
.rtc-connection-description {
  font-weight: 600;
  width: auto;
  color: #3ba55c;
}
.device-controll-wrapper {
  flex: 0 0 auto;
  margin-right: 0;
  margin-left: 10px;
  flex-direction: row;
  flex-wrap: nowrap;
  justify-content: flex-start;
  align-items: stretch;
  display: flex;
}
.camera-share-button {
  box-sizing: border-box;
  background: none;
  border: none;
  border-radius: 3px;
  font-size: 14px;
  font-weight: 500;
  line-height: 16px;
  padding: 2px 16px;
  display: flex;
  -webkit-box-pack: center;
  justify-content: center;
  -webkit-box-align: center;
  align-items: center;
  position: relative;
  background-color: #58f287;
}
.camera-share-off {
  background-color: #2f3136;
}
.my-section {
  -webkit-box-flex: 0;
  flex: 0 0 auto;
  background-color: #292b2f;
  z-index: 1;
}
.my-section-container {
  height: 52px;
  font-size: 14px;
  font-weight: 500;
  display: flex;
  -webkit-box-align: center;
  align-items: center;
  padding: 0 8px;
  margin-bottom: 1px;
  flex-shrink: 0;
}
.nametag {
  cursor: pointer;
  user-select: text;
  -webkit-box-flex: 1;
  flex-grow: 1;
  margin-right: 4px;
  min-width: 0;
}
.myname-container {
  display: flex;
  -webkit-box-align: center;
  align-items: center;
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
  font-size: 14px;
  line-height: 18px;
}
.myname {
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
  color: var(--white-color);
  line-height: 18px;
  font-weight: 600;
  font-size: 14px;
  line-height: 18px;
}
.mycode {
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
  color: var(--description-primary);
  line-height: 13px;
  font-size: 12px;
  line-height: 16px;
}
.mydevice-controller {
  flex: 0 1 auto;
  -webkit-box-orient: horizontal;
  -webkit-box-direction: normal;
  flex-direction: row;
  flex-wrap: nowrap;
  -webkit-box-pack: start;
  justify-content: flex-start;
  -webkit-box-align: stretch;
  align-items: stretch;
  display: flex;
}
.device-controll-button {
  line-height: 0;
  width: 32px;
  height: 32px;
  display: flex;
  -webkit-box-align: center;
  align-items: center;
  -webkit-box-pack: center;
  justify-content: center;
  border-radius: 4px;
  position: relative;
  color: var(--description-primary);
  font-size: 14px;
  font-weight: 500;
  background: #00000000;
  border: 0;
  padding: 0;
  margin: 0;
}
.mute {
  display: flex;
  background-image: url("../../assets/mute.svg");
  width: 12px;
  height: 17px;
}
.mute-on {
  display: flex;
  background-image: url("../../assets/mute-on.svg");
  width: 20px;
  height: 20px;
}
.deafen {
  display: flex;
  background-image: url("../../assets/deafen.svg");
  width: 16px;
  height: 16px;
}
.deafen-on {
  display: flex;
  background-image: url("../../assets/deafen_on.svg");
  width: 20px;
  height: 20px;
}
.settings {
  display: flex;
  background-image: url("../../assets/settings.svg");
  width: 16px;
  height: 16px;
}
</style>
