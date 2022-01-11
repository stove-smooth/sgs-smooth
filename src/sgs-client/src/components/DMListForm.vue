<template>
  <div>
    <div v-for="(item, index) in friends" :key="index">
      <div class="primary-member-container">
        <div
          class="primary-member-layout"
          @mouseover="hold(index)"
          @mouseleave="unhold"
        >
          <div class="avatar-container">
            <div class="profile-wrapper" aria-label="칭구1">
              <div class="avatar-wrapper">
                <img
                  class="avatar"
                  src="https://cdn.discordapp.com/avatars/846330810000605208/e581f53f2ba1f0d06bbcd7b512834a47.webp?size=32"
                  alt=" "
                />
                <template aria-label="status-invisible">
                  <div class="status-ring">
                    <div class="status-offline"></div>
                  </div>
                </template>
              </div>
            </div>
          </div>
          <div class="friends-contents">
            <div class="friends-name-decorator">
              <div class="friends-name">{{ item.name }}</div>
              <svg class="close-dm" v-show="upHere === index"></svg>
            </div>
            <div class="subtext-decorator">
              <div class="subtext" v-show="false">멤버 3명.</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      upHere: "",
      friends: [{ name: "두리짱" }, { name: "병각" }, { name: "히동" }],
    };
  },
  methods: {
    hold(index) {
      this.upHere = index;
    },
    unhold() {
      this.upHere = "";
    },
  },
};
</script>

<style>
.close-dm {
  display: flex;
  background-image: url("../assets/close-dm.svg");
  width: 20px;
  height: 20px;
}
</style>
