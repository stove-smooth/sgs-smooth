<template>
  <nav class="nav-wrapper" aria-label="서버 사이드바.">
    <ul role="tree" tabindex="0" data-list-id="guildnav" class="tree">
      <div class="thin-scrollbar nav-scroller">
        <div class="primary-container">
          <div
            class="listItem"
            @mouseover="hover('@me')"
            @mouseleave="hover('')"
            @click="enter('@me')"
          >
            <div
              class="selected-wrapper"
              v-show="hovered === '@me' || navigationSelected === '@me'"
            >
              <span class="selected-item"></span>
            </div>
            <div class="listItem-wrapper">
              <div
                class="circleIcon-button"
                v-bind:class="{
                  'circleIcon-button-hovered':
                    hovered === '@me' || navigationSelected === '@me',
                }"
              >
                <svg class="discord-logo"></svg>
              </div>
              <div class="lower-badge" v-show="friendsWaitNumber">
                <number-badge :alarms="friendsWaitNumber"></number-badge>
              </div>
            </div>
          </div>
        </div>

        <div
          aria-label="room"
          v-if="
            communityList &&
            communityList.rooms &&
            communityList.rooms.length > 0
          "
        >
          <div v-for="unreadDm in communityList.rooms" :key="unreadDm.id">
            <div
              class="listItem"
              @mouseover="hover(unreadDm.id)"
              @mouseleave="hover('')"
              @click="enterRoom(unreadDm.id)"
            >
              <div class="selected-wrapper" v-show="hovered == unreadDm.id">
                <span class="selected-item"></span>
              </div>
              <div draggable="true">
                <div class="listItem-wrapper">
                  <div class="server-wrapper" v-if="unreadDm.icon">
                    <img
                      :src="unreadDm.icon"
                      alt="image"
                      class="server-nav-image"
                      v-bind:class="{
                        'selected-border-radius': hovered == unreadDm.id,
                      }"
                    />
                  </div>
                  <div class="server-wrapper" v-else>
                    <div
                      class="server"
                      v-bind:class="{
                        'selected-border-radius': hovered == unreadDm.id,
                      }"
                    >
                      {{ unreadDm.name }}
                    </div>
                  </div>
                  <div class="alarm-ring">
                    <div class="room-lower-badge">
                      <number-badge :alarms="unreadDm.count"></number-badge>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="listItem">
          <div class="guild-seperator"></div>
        </div>
        <div
          aria-label="서버"
          v-if="communityList && communityList.communities.length > 0"
        >
          <!--서버 개수만큼 만들기.-->
          <draggable
            :list="communityList.communities"
            @change="log"
            group="community"
          >
            <div
              v-for="community in communityList.communities"
              :key="community.id"
            >
              <div
                class="listItem"
                @mouseover="hover(community.id)"
                @mouseleave="hover('')"
                @click="enter(community.id)"
              >
                <div
                  class="selected-wrapper"
                  v-show="
                    hovered == community.id ||
                    navigationSelected == community.id
                  "
                >
                  <span class="selected-item"></span>
                </div>
                <div draggable="true">
                  <div class="listItem-wrapper">
                    <div class="server-wrapper" v-if="community.icon">
                      <img
                        :src="community.icon"
                        alt="image"
                        class="server-nav-image"
                        v-bind:class="{
                          'selected-border-radius':
                            hovered == community.id ||
                            navigationSelected == community.id,
                        }"
                      />
                    </div>
                    <div class="server-wrapper" v-else>
                      <div
                        class="server"
                        v-bind:class="{
                          'selected-border-radius':
                            hovered == community.id ||
                            navigationSelected == community.id,
                        }"
                      >
                        {{ community.name }}
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </draggable>
        </div>
        <div class="primary-container">
          <div class="listItem" @click="setCreateCommunity(true)">
            <div claass="listItem-wrapper">
              <div class="circleIcon-button">
                <svg class="plus-icon"></svg>
              </div>
            </div>
          </div>
        </div>
        <div class="listItem">
          <div class="guild-seperator"></div>
        </div>
      </div>
    </ul>
  </nav>
</template>

<script>
import draggable from "vuedraggable";
import { mapState, mapMutations, mapActions } from "vuex";
import { moveCommunity } from "../api";
import NumberBadge from "./common/NumberBadge.vue";
export default {
  components: { NumberBadge, draggable },
  data() {
    return {
      hovered: "",
      images: "",
      new: 0,
    };
  },
  methods: {
    ...mapActions("community", ["fetchMyCommunityList"]),
    ...mapMutations("community", ["setCreateCommunity", "setCommunityList"]),
    ...mapMutations("utils", ["setNavigationSelected"]),
    ...mapMutations("voice", ["setCurrentVoiceRoom"]),
    ...mapActions("voice", ["sendMessage", "leaveRoom"]),
    hover(index) {
      this.hovered = index;
    },
    select(index) {
      this.setNavigationSelected(index);
    },
    unselect() {
      this.setNavigationSelected("");
    },
    enter(index) {
      //서버를 바꾸는 것.
      if (this.wsOpen) {
        this.sendMessage({ id: "leaveRoom" });
        this.leaveRoom();
        this.setCurrentVoiceRoom(null);
      }
      if (this.stompSocketClient) {
        const subscriptions = this.stompSocketClient.subscriptions;
        Object.keys(subscriptions).forEach((subscription) => {
          this.stompSocketClient.unsubscribe(subscription);
        });
      }
      if (this.$route.path !== "/channels/" + index) {
        this.$router.push("/channels/" + index);
      }
      this.setNavigationSelected(index);
    },
    enterRoom(index) {
      //안읽은 DM으로 입장.
      if (this.wsOpen) {
        this.sendMessage({ id: "leaveRoom" });
        this.leaveRoom();
        this.setCurrentVoiceRoom(null);
      }

      if (this.stompSocketClient) {
        const subscriptions = this.stompSocketClient.subscriptions;
        Object.keys(subscriptions).forEach((subscription) => {
          this.stompSocketClient.unsubscribe(subscription);
        });
      }
      this.$router.push("/channels/@me/" + index);
      //읽음 처리..
      let array = this.communityList.rooms.filter(
        (element) => element.id !== index
      );
      this.communityList.rooms = array;
      this.setCommunityList(this.communityList);
    },
    log: async function (evt) {
      if (evt.moved.newIndex == 0) {
        this.new = 0;
      } else {
        this.new = this.communityList.communities[evt.moved.newIndex - 1].id;
      }
      const communityInfo = {
        id: evt.moved.element.id,
        next: this.new,
      };
      try {
        await moveCommunity(communityInfo);
      } catch (err) {
        console.log(err.response);
      }
    },
  },
  computed: {
    ...mapState("friends", ["friendsWaitNumber"]),
    ...mapState("community", ["communityList"]),
    ...mapState("utils", ["navigationSelected", "stompSocketClient"]),
    ...mapState("voice", ["wsOpen"]),
  },
  async created() {
    const currentUrl = window.location.pathname;
    let array = currentUrl.split("/");
    this.setNavigationSelected(array[2]);
    await this.fetchMyCommunityList();
  },
  watch: {
    // 라우터의 변경을 감시
    async $route(to) {
      await this.fetchMyCommunityList();
      if (to.path == "/channels/@me") {
        this.setNavigationSelected("@me");
      }
    },
  },
};
</script>

<style>
.nav-wrapper {
  position: relative;
  width: 72px;
  flex-shrink: 0;
  overflow: hidden;
  display: flex;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  flex-direction: column;
  background-color: var(--dark-grey-color);
}

.tree {
  display: flex;
  height: 100%;
  padding: 0;
}
.nav-scroller {
  overflow: hidden scroll;
  padding-right: 0px;
  background-color: var(--dark-grey-color);
}
.primary-container {
  position: relative;
}
.listItem {
  position: relative;
  margin: 0 0 8px;
  display: flex;
  -webkit-box-pack: center;
  justify-content: center;
  width: 72px;
}
.selected-wrapper {
  position: absolute;
  top: 0;
  left: 0;
  overflow: hidden;
  width: 8px;
  height: 48px;
  display: flex;
  -webkit-box-align: center;
  align-items: center;
  -webkit-box-pack: start;
  justify-content: flex-start;
}
.selected-item {
  opacity: 1;
  height: 40px;
  transform: none;
  position: absolute;
  display: block;
  width: 8px;
  border-radius: 0 4px 4px 0;
  margin-left: -4px;
  background-color: var(--white-color);
}
.listItem-wrapper {
  box-sizing: border-box;
  position: relative;
  width: 48px;
  height: 48px;
  cursor: pointer;
}

.discord-logo {
  display: flex;
  background-image: url("../assets/discord-logo.svg");
  width: 27px;
  height: 22px;
}
.guild-seperator {
  height: 2px;
  width: 32px;
  border-radius: 1px;
  background-color: hsla(0, 0%, 100%, 0.06);
}

.server {
  font-weight: 500;
  line-height: 1.2em;
  white-space: nowrap;
  background-color: #36393f;
  color: #dcddde;
  display: flex;
  width: 48px;
  height: 48px;
  -webkit-box-align: center;
  align-items: center;
  -webkit-box-pack: center;
  justify-content: center;
  overflow: hidden;
  border-radius: 50%;
}
.server-wrapper {
  font-size: 12px;
  display: flex;
  width: 48px;
  height: 48px;
  -webkit-box-align: center;
  align-items: center;
  -webkit-box-pack: center;
  justify-content: center;
}
.circleIcon-button {
  cursor: pointer;
  display: flex;
  -webkit-box-align: center;
  align-items: center;
  -webkit-box-pack: center;
  justify-content: center;
  box-sizing: border-box;
  width: 48px;
  height: 48px;
  border-radius: 50%;
  background-color: #36393f;
}

.circleIcon-button-hovered {
  border-radius: 30%;
  background-color: var(--discord-primary);
}

.plus-icon {
  display: flex;
  width: 16px;
  height: 16px;
  background-image: url("../assets/channel-plus.svg");
}

.server-nav-image {
  display: flex;
  width: 48px;
  height: 48px;
  border-radius: 50%;
  position: relative;
}

.lower-badge {
  opacity: 1;
  transform: translate(0px, 0px);
  pointer-events: none;
  position: absolute;
  right: 0;
  bottom: 0;
}

.room-lower-badge {
  opacity: 1;
  transform: translate(0px, 0px);
  pointer-events: none;
  position: absolute;
  right: 15%;
  bottom: 15%;
}

.selected-border-radius {
  border-radius: 30%;
}
ol,
ul {
  list-style: none;
}
</style>
