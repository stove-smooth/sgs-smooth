<template>
  <div :id="containerId" class="video-unit-container">
    <div :id="videoWrapperId" class="display-flex"></div>
    <!-- <div v-show="!participant.rtcPeer.videoEnabled">
      <img class="no-video-img" src="../assets/default_stove.png" />
    </div> -->
    <span class="text-align-center">{{ nickname }}</span>
  </div>
</template>

<script>
import { fetchMemberInfo } from "../api";
export default {
  props: {
    participant: {
      type: Object,
    },
  },
  data() {
    return {
      nickname: "",
    };
  },
  computed: {
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
      const result = await fetchMemberInfo(this.participant.name);
      if (result.data.code == 1000) {
        this.nickname = result.data.result.name;
      }
    },
  },
  mounted() {
    document.getElementById(this.videoWrapperId).appendChild(this.video);
    var newArea = document.createElement("div");
    newArea.classList.add("video-unit-container");
    document.getElementById(this.videoWrapperId).appendChild(newArea);
  },
};
</script>

<style>
.video-unit-container {
  width: 85%;
  height: 85%;
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
/* .video-wrapper {
  width: 240px;
  height: 240px;
} */
.no-video-container {
  /*   width: 240px;
  height: 240px;
  display: flex; */
}
.no-video-img {
  width: 100%;
  height: 100%;
}
</style>
