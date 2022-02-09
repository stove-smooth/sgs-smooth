<template>
  <div :id="containerId" class="video-unit-container">
    <div class="overlay">
      <span>{{}}</span>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    participant: {
      type: Object,
    },
  },
  computed: {
    video() {
      return this.participant.getVideoElement();
    },
    containerId() {
      return "video-" + this.participant.name + "-container";
    },
  },
  mounted() {
    console.log("마운트되니? , this.participant.rtcPeer.videoEnabled");
    //video위에 보이는지 유무
    this.video.classList.add("video-insert");
    document.getElementById(this.containerId).appendChild(this.video);
  },
};
</script>

<style>
.video-unit-container {
  position: relative;
}
.video-insert {
  height: 100%;
  border-radius: 25px;
  box-shadow: 0px 4px 4px black;
  transform: scale(-1, 1);
}
</style>
