<template>
  <div :id="containerId" class="video-unit-container">
    <div :id="videoWrapperId" class="display-flex" style="width: 100%"></div>
    <span class="text-align-center">{{ nickname }}</span>
  </div>
</template>

<script>
import { mapGetters, mapState } from "vuex";
import { fetchMemberInfo } from "@/api";
export default {
  props: {
    participant: {
      type: Object,
    },
  },
  data() {
    return {
      nickname: "",
      auto_reload_func: null,
    };
  },
  computed: {
    ...mapGetters("user", ["getUserId"]),
    ...mapState("voice", ["currentVoiceRoomType"]),
    ...mapState("community", [
      "communityOnlineMemberList",
      "communityOfflineMemberList",
    ]),
    video() {
      return this.participant.getVideoElement();
    },
    containerId() {
      return "video-" + this.participant.name + "-container";
    },
    videoWrapperId() {
      return "video-" + this.participant.name + "-wrapper";
    },
  },
  methods: {
    async participantNickName() {
      if (this.currentVoiceRoomType == "mobile") {
        const result = await fetchMemberInfo(this.participant.name);
        if (result.data.code == 1000) {
          this.nickname = result.data.result.name;
        }
      } else {
        let communityMembers = this.communityOnlineMemberList.concat(
          this.communityOfflineMemberList
        );
        for (let i = 0; i < communityMembers.length; i++) {
          if (communityMembers[i].id == this.participant.name) {
            this.nickname = communityMembers[i].communityName;
          }
        }
      }
    },
    getAudioLevel() {
      if (this.participant.name !== this.getUserId) {
        this.participant.rtcPeer.peerConnection.getStats(null).then((stats) => {
          stats.forEach((report) => {
            if (report.type === "inbound-rtp" && report.kind === "audio") {
              if (report.audioLevel > 0.01) {
                this.video.classList.add("saying");
              } else {
                this.video.classList.remove("saying");
              }
            }
          });
        });
      } else {
        this.participant.rtcPeer.peerConnection.getStats(null).then((stats) => {
          stats.forEach((report) => {
            if (report.type === "media-source" && report.kind === "audio") {
              if (report.audioLevel > 0.01) {
                this.video.classList.add("saying");
              } else {
                this.video.classList.remove("saying");
              }
            }
          });
        });
      }
    },
  },
  async mounted() {
    await document.getElementById(this.videoWrapperId).appendChild(this.video);
    this.participantNickName();
    this.auto_reload_func = setInterval(this.getAudioLevel, 500);
  },
  destroyed() {
    clearInterval(this.auto_reload_func);
  },
};
</script>

<style>
.video-unit-container {
  /* width: 85%;
  height: 85%; */
  display: flex;
  flex-direction: column;
  color: white;
  justify-content: center;
  align-items: center;
}
.video-insert {
  height: 100%;
  border-radius: 25px;
  box-shadow: 0px 4px 4px black;
  transform: scale(-1, 1);
}
.no-video-img {
  width: 100%;
  height: 100%;
}
.saying {
  border: 2px solid blue;
}
</style>
