<template>
  <div class="friends-now-playing-list">
    <div
      class="frineds-now-playing-container thin-scrollbar now-playing-scroller"
    >
      <h3 class="header-title">현재 활동 중</h3>
      <div v-for="friend in this.friendsOnline" :key="friend.id">
        <div class="now-playing-card" tabindex="0" role="button">
          <div>
            <header class="now-playing-card-header">
              <div class="profile-margin profile-wrapper">
                <img class="avatar" :src="friend.profileImage" alt=" " />
                <template aria-label="status-invisible">
                  <div class="status-ring">
                    <div class="status-online"></div>
                  </div>
                </template>
              </div>
              <div>
                <div class="large-white-description primary-text-content">
                  {{ friend.name }}
                </div>
                <div
                  v-if="friend.onlineState.startsWith('com')"
                  class="primary-text-content status-description"
                >
                  음성 채널 참여 중
                </div>
                <div class="primary-text-content status-description" v-else>
                  온라인
                </div>
              </div>
            </header>
            <div class="now-playing-card-body">
              <section class="now-playing-server-container">
                <div class="now-playing-server">
                  <div tabindex="-1" role="button">
                    <div
                      class="profile-wrapper justify-content-center align-items-center"
                    >
                      <template v-if="computeCommunityImage(friend) != 'lobby'">
                        <img
                          class="profile-wrapper"
                          alt="image"
                          :src="computeCommunityImage(friend)"
                        />
                        <div class="voice-section-wrapper">
                          <svg class="small-voice-channel"></svg>
                        </div>
                      </template>
                      <template
                        v-else
                        v-bind:style="{ width: '22px', height: '22px' }"
                        ><svg class="place-home"></svg>
                      </template>
                    </div>
                  </div>
                  <div tabindex="0" role="button">
                    <div class="clickable" aria-label="voice-section-details">
                      <div class="large-white-description primary-text-content">
                        {{ computeCommunityName(friend) }}
                      </div>
                    </div>
                  </div>
                </div>
              </section>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from "vuex";
export default {
  computed: {
    ...mapState("friends", ["friendsOnline"]),
    ...mapState("community", ["communityList"]),
  },
  methods: {
    computeCommunityImage(friend) {
      if (friend.onlineState.startsWith("com")) {
        console.log("서버에 있을때", this.communityList);
        let server = friend.onlineState.split(",");
        let serverId = server[0].split("m");
        console.log("server", serverId); //serverId[1]
        for (let i = 0; i < this.communityList.length; i++) {
          if (this.communityList[i].id == serverId[1]) {
            console.log("ddddd", this.communityList[i].icon);
            return this.communityList[i].icon;
          }
        }
      } else {
        return "lobby";
      }
    },
    computeCommunityName(friend) {
      if (friend.onlineState.startsWith("com")) {
        console.log("서버에 있을때", friend.onlineState, this.communityList);
        let server = friend.onlineState.split(",");
        let serverId = server[0].split("m");
        console.log("server", serverId); //serverId[1]
        for (let i = 0; i < this.communityList.length; i++) {
          if (this.communityList[i].id == serverId[1]) {
            console.log("ddddd", this.communityList[i].icon);
            return this.communityList[i].name;
          }
        }
      } else {
        return "lobby";
      }
    },
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
