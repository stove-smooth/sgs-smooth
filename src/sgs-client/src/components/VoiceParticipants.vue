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
    console.log("원본participants", this.participant);
    console.log("video", this.video);
    this.video.classList.add("video-insert");
    document.getElementById(this.containerId).appendChild(this.video);
    //let parsedParticipants = JSON.stringify(this.participants);
    /* for (let key in this.participants) {
      this.participants[key].getVideoElement().classList.add("video-insert"); //-> 키값, 모든 value 출력
      document
        .getElementById("main-video-container")
        .appendChild(this.mainVideo);
    } */
    /* console.log("participants", parsedParticipants);
    for (var i = 0; i < parsedParticipants.length; i++) {
      console.log("participants", parsedParticipants[i]);
    } */
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
