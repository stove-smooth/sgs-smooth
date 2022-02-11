<template>
  <div class="server-member-container">
    <aside class="server-member-list-wrapper">
      <div class="thin-scrollbar dm-scroller server-members" tabinex="0">
        <div
          role="list"
          aria-label="멤버"
          class="server-member-list"
          v-show="directMessageMemberList != null"
        >
          <h2 class="members-group-container" aria-label="멤버">
            멤버-{{ directMessageMemberList.count }}
          </h2>
          <div
            v-for="directMessageMember in directMessageMemberList.members"
            :key="directMessageMember.id"
          >
            <div class="primary-member-container clickable" role="listitem">
              <div class="primary-member-layout">
                <div class="avatar-container">
                  <div class="profile-wrapper">
                    <div class="avatar-wrapper">
                      <img
                        class="avatar"
                        :src="directMessageMember.image"
                        alt=" "
                      />
                      <template aria-label="status-invisible">
                        <div class="status-ring">
                          <div
                            v-if="directMessageMember.state == 'online'"
                            class="status-online"
                          />
                          <div v-else class="status-offline" />
                        </div>
                      </template>
                    </div>
                  </div>
                </div>
                <div class="friends-contents">
                  <div class="friends-name-decorator">
                    <div class="friends-name">
                      {{ directMessageMember.nickname
                      }}<svg
                        v-show="directMessageMember.owner"
                        class="crown"
                      ></svg>
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
import { mapState, mapActions } from "vuex";
export default {
  //추가할지 말지 고려중인 동작입니다.
  /* mounted() {
    window.addEventListener("click", this.onClick);
  }, */
  created() {
    this.fetchDirectMessageMemberList(this.$route.params.id);
  },
  computed: {
    ...mapState("dm", ["directMessageMemberList"]),
  },
  methods: {
    ...mapActions("dm", ["fetchDirectMessageMemberList"]),
    //추가할지 말지 고려중인 동작입니다.
    /* ...mapMutations("server", ["setServerMemberPlusMenu"]),
    ...mapMutations("utils", ["setClientX", "setClientY"]), */
    /* clickMemberPlusAction(event, memberInfo) {
      const x = event.clientX;
      const y = event.clientY;
      this.setClientX(x);
      this.setClientY(y);
      this.setServerMemberPlusMenu(memberInfo);
    }, */
    /* onClick(e) {
      if (this.serverMemberPlusMenu) {
        if (
          e.target.className !== "friends-name" &&
          e.target.className !== "avatar-wrapper" &&
          e.target.className !== "primary-member-layout" &&
          e.target.className !== "friends-name-decorator"
        ) {
          this.setServerMemberPlusMenu(null);
        }
      }
    }, */
  },
};
</script>

<style></style>
