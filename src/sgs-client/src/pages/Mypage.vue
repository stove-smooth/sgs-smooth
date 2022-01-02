<template>
  <div class="layer">
    <div class="content-mypage">
      <div class="sidebar">
        <friends-side-bar></friends-side-bar>
        <user-section></user-section>
      </div>
    </div>
  </div>
</template>

<script>
import FriendsSideBar from "../components/FriendsSideBar.vue";
import UserSection from "../components/UserSection.vue";
export default {
  components: {
    FriendsSideBar,
    UserSection,
  },
};
</script>

<style>
.content-mypage {
  display: flex;
  -webkit-box-align: stretch;
  align-items: stretch;
  -webkit-box-pack: start;
  justify-content: flex-start;
  min-width: 0;
  min-height: 0;
  -webkit-box-flex: 1;
  flex: 1 1 auto;
}
.sidebar {
  display: flex;
  flex-direction: column;
  min-height: 0;
  width: 240px;
  -webkit-box-flex: 0;
  /*   -ms-flex: 0 0 auto; */
  flex: 0 0 auto;
  background: #2f3136;
}
.try {
  overflow: hidden scroll;
}
.dm-scroller {
  overflow: hidden scroll;
  padding-right: 0px;
  background-color: #2f3136;
}
.thin-scrollbar::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}
.thin-scrollbar::-webkit-scrollbar-corner {
  background-color: #00000000;
}
.thin-scrollbar::-webkit-scrollbar-thumb {
  background-clip: padding-box;
  border: 2px solid #00000000;
  border-radius: 4px;
  background-color: #202225;
  min-height: 40px;
}
.thin-scrollbar::-webkit-scrollbar-track {
  border-color: #00000000;
  background-color: #00000000;
  border: 2px solid #00000000;
}
</style>
