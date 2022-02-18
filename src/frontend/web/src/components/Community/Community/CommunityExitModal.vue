<template>
  <div class="modal" v-if="communityReadyToExit">
    <div class="blurred-background" @click="exitModal"></div>
    <div class="modal-container">
      <modal @exit="exitModal">
        <template slot="header">
          <h3 class="modal-big-title">
            {{ communityReadyToExit.serverName }}서버 퇴장
          </h3>
        </template>
        <template slot="content">
          <div class="modal-subtitle">
            이 서버에서 나가면 다시 초대를 받아야 하는데 정말
            {{ communityReadyToExit.serverName }}에서 나갈건가요?
          </div>
        </template>
        <template slot="footer">
          <div class="submit-server-form-footer">
            <button
              type="button"
              class="medium-submit-button"
              @click="exitCommunity(communityReadyToExit.serverId)"
            >
              <div>서버 나가기</div>
            </button>
            <button class="back-button" @click="exitModal">취소</button>
          </div>
        </template>
      </modal>
    </div>
  </div>
</template>

<script>
import { mapState, mapMutations, mapGetters } from "vuex";
import { exitCommunity } from "@/api";
import Modal from "@/components/common/Modal.vue";

export default {
  components: {
    Modal,
  },
  computed: {
    ...mapState("community", ["communityReadyToExit", "communityList"]),
    ...mapGetters("user", ["getUserId"]),
  },
  methods: {
    ...mapMutations("community", [
      "setCommunityReadyToExit",
      "setCommunityList",
    ]),
    exitModal() {
      this.setCommunityReadyToExit(false);
    },
    async exitCommunity(communityId) {
      try {
        await exitCommunity(communityId, this.getUserId);
        this.setCommunityReadyToExit(false);
        for (let i = 0; i < this.communityList.communities.length; i++) {
          if (this.communityList.communities[i].id == communityId) {
            this.communityList.communities.splice(i, 1);
          }
        }
        this.$router.replace("/channels/@me");
      } catch (err) {
        if (err.response.data.code === 1400) {
          alert("잘못된 요청입니다.");
        } else if (err.response.data.code === 1401) {
          alert("요청 권한이 없습니다.");
        } else if (err.response.data.code === 1500) {
          alert("서버 내부 에러입니다.");
        } else if (err.response.data.code === 4002) {
          alert("유효하지 않은 커뮤니티입니다.");
        } else if (err.response.data.code === 4007) {
          alert("커뮤니티에 존재하지 않는 회원입니다.");
        } else {
          alert("잘못된 요청입니다.");
        }
      }
    },
  },
};
</script>

<style></style>
