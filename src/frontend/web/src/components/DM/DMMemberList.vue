<template>
  <div class="server-member-container">
    <aside class="server-member-list-wrapper">
      <div class="thin-scrollbar dm-scroller server-members" tabinex="0">
        <div
          role="list"
          aria-label="멤버"
          class="server-member-list"
          v-if="directMessageMemberList != null"
        >
          <h2 class="members-group-container" aria-label="멤버">
            멤버-{{ directMessageMemberList.count }}
          </h2>
          <div
            v-for="directMessageMember in directMessageMemberList.members"
            :key="directMessageMember.id"
          >
            <div
              class="primary-member-container clickable"
              @click="clickMemberPlusAction($event, directMessageMember)"
              role="listitem"
            >
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
import { mapState, mapActions, mapMutations } from "vuex";
import { clickPlusAction, closeMemberPlusMenu } from '@/utils/common';
export default {
  mounted() {
    window.addEventListener("click", this.onClick);
  },
  created() {
    this.fetchDirectMessageMemberList(this.$route.params.id);
  },
  computed: {
    ...mapState("dm", ["directMessageMemberList"]),
    ...mapState("community", ["communityMemberPlusMenu"]),
  },
  methods: {
    ...mapActions("dm", ["fetchDirectMessageMemberList"]),
    ...mapMutations("community", ["setCommunityMemberPlusMenu"]),
    ...mapMutations("utils", ["setClientX", "setClientY"]),
    clickMemberPlusAction(event, memberInfo) {
      clickPlusAction(event);
      this.setCommunityMemberPlusMenu(memberInfo);
    },
    onClick(e) {
      if (this.communityMemberPlusMenu) {
        closeMemberPlusMenu(e);
      }
    },
  },
  beforeDestroy(){
    window.removeEventListener("click", this.onClick);
  },
};
</script>