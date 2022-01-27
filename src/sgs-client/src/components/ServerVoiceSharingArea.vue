<template>
  <div class="voice-sharing-container flex-direction-column">
    <server-chatting-menu-bar></server-chatting-menu-bar>
    <div class="voice-participant-sharing">
      <div class="wrap">
        <div class="scroll__wrap scrollbar-ghost">
          <div class="scroll--element">Element1</div>
          <div class="scroll--element">Element2</div>
          <div class="scroll--element">Element3</div>
          <div class="scroll--element">Element4</div>
          <div class="scroll--element">Element5</div>
          <div class="scroll--element">Element6</div>
        </div>
      </div>
    </div>
    <div class="voice-bottom-control-section"></div>
  </div>
</template>

<script>
import ServerChattingMenuBar from "./ServerChattingMenuBar.vue";
export default {
  components: {
    ServerChattingMenuBar,
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
}
.voice-bottom-control-section {
  display: flex;
  -webkit-box-align: center;
  align-items: center;
  -webkit-box-pack: justify;
  justify-content: space-between;
  line-height: 0;
  height: 50px;
  background-color: blanchedalmond;
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
</style>
