<template>
  <div class="layer">
    <div class="content-mypage">
      <div class="sidebar">
        <friends-side-bar></friends-side-bar>
        <user-section></user-section>
      </div>
      <div class="friends-state-container">
        <friends-state-menu-bar></friends-state-menu-bar>
        <friends-state-list></friends-state-list>
      </div>
    </div>
  </div>
</template>

<script>
import FriendsSideBar from "../components/FriendsSideBar.vue";
import FriendsStateList from "../components/FriendsStateList.vue";
import FriendsStateMenuBar from "../components/FriendsStateMenuBar.vue";
import UserSection from "../components/common/UserSection.vue";
export default {
  components: {
    FriendsSideBar,
    UserSection,
    FriendsStateMenuBar,
    FriendsStateList,
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
  overflow: hidden;
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
  background-color: var(--dark-grey-color);
  min-height: 40px;
}
.thin-scrollbar::-webkit-scrollbar-track {
  border-color: #00000000;
  background-color: #00000000;
  border: 2px solid #00000000;
}

.friends-state-container {
  background-color: #36393f;
  display: flex;
  width: 100%;
  overflow: hidden;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  /*  -ms-flex-direction: column; */
  flex-direction: column;
}
</style>
