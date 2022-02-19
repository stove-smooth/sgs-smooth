<template>
  <div>
    <div v-for="item in directMessageList" :key="item.id">
      <div class="primary-member-container">
        <div
          class="primary-member-layout"
          @mouseover="hold(item.id)"
          @mouseleave="unhold"
          @click="routePrivateDM(item.id)"
          v-bind:class="{
            'primary-member-layout-hover': $route.params.id == item.id,
          }"
        >
          <div class="avatar-container">
            <div class="profile-wrapper" aria-label="칭구1">
              <div class="avatar-wrapper">
                <img class="avatar" :src="item.icon" alt=" " />
                <template aria-label="status-invisible">
                  <div class="status-ring" v-show="!item.group">
                    <div
                      v-if="item.state == 'online'"
                      class="status-online"
                    ></div>
                    <div v-else class="status-offline"></div>
                  </div>
                </template>
              </div>
            </div>
          </div>
          <div class="friends-contents">
            <div class="friends-name-decorator">
              <div class="friends-name">{{ item.name }}</div>
              <svg
                class="primary-close"
                v-show="upHere === item.id"
                @click.stop.prevent="exitDirectMessage(item.id)"
              ></svg>
            </div>
            <div class="subtext-decorator">
              <div class="subtext" v-show="item.group">
                멤버 {{ item.count }}명
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters, mapMutations, mapActions } from "vuex";
import { exitDirectMessage } from "../../api/index";
export default {
  data() {
    return {
      upHere: "",
    };
  },
  computed: {
    ...mapState("dm", ["directMessageList"]),
    ...mapGetters("user", ["getUserId"]),
    ...mapState("voice", ["wsOpen"]),
    ...mapState("community", ["communityList"]),
  },
  methods: {
    ...mapMutations("dm", ["setDirectMessageList"]),
    ...mapActions("voice", ["sendMessage", "leaveRoom"]),
    ...mapMutations("voice", ["setCurrentVoiceRoom"]),
    hold(index) {
      this.upHere = index;
    },
    unhold() {
      this.upHere = "";
    },
    routePrivateDM(index) {
      if (this.communityList.rooms.length > 0) {
        for (let i = 0; i < this.communityList.rooms.length; i++) {
          if (this.communityList.rooms[i].id == index) {
            this.communityList.rooms.splice(i, 1);
          }
        }
      }
      if (this.wsOpen) {
        this.sendMessage({ id: "leaveRoom" });
        this.leaveRoom();
        this.setCurrentVoiceRoom(null);
      }
      if (this.$route.path !== "/channels/@me/" + index) {
        this.$router.push("/channels/@me/" + index);
      }
    },
    async exitDirectMessage(dmId) {
      const result = await exitDirectMessage(dmId, this.getUserId);
      if (result.data.code === 1000) {
        let array = this.directMessageList.filter(
          (element) => element.id !== dmId
        );
        if (this.$route.params.id == dmId) {
          this.$router.replace("/channels/@me");
        }
        this.setDirectMessageList(array);
      }
    },
  },
};
</script>

<style></style>
