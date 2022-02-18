<template>
  <div class="friends-now-playing-list">
    <div
      class="frineds-now-playing-container thin-scrollbar now-playing-scroller"
    >
      <h3 class="header-title">
        <template v-if="this.friendsOnline.length > 0">현재 활동 중</template
        ><template v-else>현재 활동 중인 친구가 없어요</template>
      </h3>
      <template v-if="this.communityList != null">
        <div v-for="friend in this.friendsOnline" :key="friend.id">
          <friends-playing-form :friend="friend"></friends-playing-form>
        </div>
      </template>
    </div>
  </div>
</template>

<script>
import { mapState, mapActions } from "vuex";
import FriendsPlayingForm from "./FriendsPlayingForm.vue";
export default {
  components: { FriendsPlayingForm },
  /* async created() {
    await this.FETCH_COMMUNITYLIST();
  }, */
  computed: {
    ...mapState("community", ["communityList"]),
    ...mapState("friends", ["friendsOnline"]),
  },
  methods: {
    ...mapActions("community", ["FETCH_COMMUNITYLIST"]),
  },
};
</script>

<style>
.friends-now-playing-list {
  -webkit-box-flex: 0;
  flex: 0 1 30%;
  min-width: 360px;
  max-width: 420px;
  background: #2f3136;
}
.frineds-now-playing-container {
  background-color: #36393f;
  height: 100%;
  border-left: 1px solid hsla(0, 0%, 100%, 0.06);
}
.now-playing-card {
  margin-top: 0;
  border-radius: 8px;
  background-color: #2f3136;
  border: 1px solid hsla(0, 0%, 100%, 0.06);
  cursor: pointer;
  padding: 16px;
}
.now-playing-card-header {
  grid-template-columns: 32px minmax(20px, auto) 24px;
  position: relative;
  display: grid;
  -webkit-box-align: center;
  align-items: center;
  height: 36px;
  grid-gap: 12px;
}
.now-playing-card-body {
  background-color: #2f3136;
  margin-top: 12px;
  border-radius: 8px;
}
.now-playing-server-container {
  border-radius: 8px;
  position: relative;
  padding: 12px;
  background-color: #36393f;
}
.now-playing-server {
  -webkit-box-align: center;
  align-items: center;
  display: grid;
  grid-template-columns: 32px minmax(20px, auto) max-content;
  grid-gap: 12px;
}
.voice-section-wrapper {
  background-color: #18191c;
  width: 16px;
  height: 16px;
  border-radius: 50%;
  display: flex;
  -webkit-box-pack: center;
  justify-content: center;
  -webkit-box-align: center;
  align-items: center;
  position: absolute;
  bottom: -2px;
  right: -2px;
}
.small-voice-channel {
  width: 10px;
  height: 10px;
  background-image: url("../../assets/small-voice-channel.svg");
}
.voice-section-members-wrapper {
  display: flex;
  height: 24px;
  -webkit-box-pack: end;
  justify-content: flex-end;
  -webkit-box-align: center;
  align-items: center;
}
.voice-section-members-wrapper {
  display: flex;
  height: 24px;
  -webkit-box-pack: end;
  justify-content: flex-end;
  -webkit-box-align: center;
  align-items: center;
}
.voice-section-members {
  display: flex;
  height: 24px;
}
.known-voice-section-member {
  width: 24px;
  height: 24px;
  display: inline-block;
}
.small-profile-wrapper {
  position: absolute;
  width: 24px;
  height: 24px;
  position: relative;
  border-radius: 50%;
}
.now-playing-scroller {
  overflow: hidden scroll;
  padding: 16px;
}
.place-home {
  width: 22px;
  height: 22px;
  background-image: url("../../assets/places-home.svg");
}
</style>
