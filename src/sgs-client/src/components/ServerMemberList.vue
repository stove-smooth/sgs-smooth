<template>
  <div class="server-member-container">
    <aside class="server-member-list-wrapper">
      <div class="thin-scrollbar dm-scroller server-members" tabinex="0">
        <div
          role="list"
          aria-label="멤버"
          class="server-member-list"
          v-show="
            communityOnlineMemberList !== undefined &&
            communityOnlineMemberList.length > 0
          "
        >
          <h2 class="members-group-container" aria-label="온라인">
            온라인 - 5
          </h2>
          <div v-for="item in communityOnlineMemberList" :key="item.id">
            <div class="primary-member-container clickable" role="listitem">
              <div class="primary-member-layout">
                <div class="avatar-container">
                  <div class="profile-wrapper" aria-label="칭구1">
                    <div class="avatar-wrapper">
                      <img
                        class="avatar"
                        :src="
                          item.profileImage
                            ? item.profileImage
                            : discordProfile(item.code)
                        "
                        alt=" "
                      />
                      <template aria-label="status-invisible">
                        <div class="status-ring">
                          <div class="status-online"></div>
                        </div>
                      </template>
                    </div>
                  </div>
                </div>
                <div class="friends-contents">
                  <div class="friends-name-decorator">
                    <div class="friends-name">
                      {{ item.nickname
                      }}<svg v-show="item.role == 'OWNER'" class="crown"></svg>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div
          role="list"
          aria-label="멤버"
          class="server-member-list"
          v-show="
            communityOfflineMemberList !== undefined &&
            communityOfflineMemberList.length > 0
          "
        >
          <h2 class="members-group-container" aria-label="오프라인">
            오프라인 - 3
          </h2>
          <div v-for="item in communityOfflineMemberList" :key="item.id">
            <div class="primary-member-container clickable" role="listitem">
              <div class="primary-member-layout">
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
                    <div class="friends-name">
                      {{ item.nickname
                      }}<svg v-show="item.role == 'OWNER'" class="crown"></svg>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </aside>
  </div>
</template>

<script>
import { mapState } from "vuex";
import { selectProfile } from "../utils/common.js";
export default {
  computed: {
    ...mapState("server", [
      "communityOnlineMemberList",
      "communityOfflineMemberList",
    ]),
  },
  methods: {
    discordProfile(code) {
      const classify = code % 4;
      const result = selectProfile(classify);
      return require("../assets/" + result + ".png");
    },
  },
};
</script>

<style>
.server-member-container {
  display: flex;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  /* -ms-flex-direction: column; */
  flex-direction: column;
  background: #2f3136;
  height: 100%;
}
.server-member-list-wrapper {
  -webkit-box-pack: center;
  justify-content: center;
  min-width: 240px;
  position: relative;
  max-height: 100%;
  display: flex;
}
.server-members {
  width: 240px;
  padding: 0 0 20px;
  -webkit-box-flex: 0;
  flex: 0 0 auto;
  height: auto;
}
.server-member-list {
  background-color: #2f3136;
  position: relative;
  height: auto;
}
.members-group-container {
  padding: 24px 8px 0 16px;
  height: 40px;
  box-sizing: border-box;
  text-overflow: ellipsis;
  white-space: nowrap;
  overflow: hidden;
  text-transform: uppercase;
  font-size: 12px;
  line-height: 16px;
  letter-spacing: 0.25px;
  font-weight: 600;
  -webkit-box-flex: 1;
  -ms-flex: 1 1 auto;
  flex: 1 1 auto;
  color: #8e9297;
}
.crown {
  width: 14px;
  height: 14px;
  background-image: url("../assets/crown.svg");
}
</style>
