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
                      v-if="item.state == '온라인'"
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
              <svg class="primary-close" v-show="upHere === item.id"></svg>
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
import { mapState } from "vuex";
export default {
  data() {
    return {
      upHere: "",
    };
  },
  computed: {
    ...mapState("dm", ["directMessageList"]),
  },
  methods: {
    hold(index) {
      this.upHere = index;
    },
    unhold() {
      this.upHere = "";
    },
    routePrivateDM(index) {
      if (this.$route.path !== "/channels/@me/" + index) {
        this.$router.push("/channels/@me/" + index);
      }
    },
  },
};
</script>

<style></style>
