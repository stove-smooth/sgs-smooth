<template>
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
                <template
                  v-if="
                    friend.onlineState.startsWith('com') &&
                    computeActivityState != null
                  "
                >
                  <img
                    class="profile-wrapper"
                    alt="image"
                    :src="computeActivityState.icon"
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
                  <template
                    v-if="
                      friend.onlineState.startsWith('com') &&
                      computeActivityState != null
                    "
                  >
                    {{ computeActivityState.name }}
                  </template>
                  <template v-else>lobby</template>
                </div>
              </div>
            </div>
          </div>
        </section>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapActions } from "vuex";
export default {
  props: {
    friend: {
      type: Object,
    },
  },
  computed: {
    ...mapState("community", ["communityList"]),
    ...mapState("friends", ["friendsOnline"]),
    computeActivityState() {
      let server = this.friend.onlineState.split(",");
      let serverId = server[0].split("m");
      let ActivityPlace = null;
      for (let i = 0; i < this.communityList.communities.length; i++) {
        if (this.communityList.communities[i].id == serverId[1]) {
          ActivityPlace = this.communityList.communities[i];
        }
      }
      return ActivityPlace;
    },
  },
  methods: {
    ...mapActions("community", ["FETCH_COMMUNITYLIST"]),
  },
};
</script>

<style></style>
