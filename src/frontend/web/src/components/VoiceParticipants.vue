<template>
  <div :id="containerId" class="video-unit-container">
    <div
      :id="videoWrapperId"
      v-show="participant.rtcPeer.videoEnabled"
      class="display-flex"
    ></div>
    <div v-show="!participant.rtcPeer.videoEnabled">
      <img class="no-video-img" src="../assets/default_stove.png" />
    </div>
    <span class="text-align-center">{{ this.nickname }}</span>
  </div>
</template>

<script>
import { mapState } from "vuex";
export default {
  props: {
    participant: {
      type: Object,
    },
  },
  computed: {
    ...mapState("user", ["nickname"]),
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
  mounted() {
    console.log(
      "마운트되니? , this.participant.rtcPeer.videoEnabled",
      this.participant.rtcPeer.videoEnabled
    );

    //video위에 보이는지 유무
    document.getElementById(this.videoWrapperId).appendChild(this.video);
    var newArea = document.createElement("div");
    newArea.classList.add("video-unit-container");
    document.getElementById(this.videoWrapperId).appendChild(newArea);
  },
};
</script>

<style>
.video-unit-container {
  width: 240px;
  height: 240px;
  display: flex;
  flex-direction: column;
  color: white;
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
