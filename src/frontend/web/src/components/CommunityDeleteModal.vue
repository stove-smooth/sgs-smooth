<template>
  <div class="modal" v-if="communityReadyToDelete">
    <div class="blurred-background" @click="exitModal"></div>
    <div class="modal-container">
      <modal @exit="exitModal">
        <template slot="header">
          <h3 class="modal-big-title">서버 삭제</h3>
        </template>
        <template slot="content">
          <div class="modal-subtitle">
            정말 {{ communityReadyToDelete.serverName }} 서버를 삭제할까요?
            삭제하면 되돌릴 수 없어요.
          </div>
        </template>
        <template slot="footer">
          <div class="submit-server-form-footer">
            <button
              type="button"
              class="medium-submit-button"
              @click="deleteCommunity(communityReadyToDelete.serverId)"
            >
              <div>서버 삭제</div>
            </button>
            <button class="back-button" @click="exitModal">취소</button>
          </div>
        </template>
      </modal>
    </div>
  </div>
</template>

<script>
import Modal from "./common/Modal.vue";
import { mapState, mapMutations } from "vuex";
import { deleteCommunity } from "../api/index.js";
export default {
  components: { Modal },
  computed: {
    ...mapState("server", ["communityReadyToDelete", "communityList"]),
  },
  methods: {
    ...mapMutations("server", [
      "setCommunityReadyToDelete",
      "setServerSettingModal",
      "setCommunityOnlineMemberList",
      "setCommunityOfflineMemberList",
      "setCommunityInfo",
      "setCommunityList",
    ]),
    exitModal() {
      this.setCommunityReadyToDelete(null);
    },
    async deleteCommunity(communityId) {
      try {
        await deleteCommunity(communityId);
        this.setCommunityReadyToDelete(null);
        this.setServerSettingModal(null);
        this.setCommunityOnlineMemberList(null);
        this.setCommunityOfflineMemberList(null);
        this.setCommunityInfo(null);
        let array = this.communityList.filter(
          (element) => element.id !== communityId
        );
        this.setCommunityList(array);

        this.$router.replace("/channels/@me");
      } catch (err) {
        console.log(err, "에러", err.response, communityId);
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
        } else if (err.response.data.code === 4009) {
          alert("이미 해당 위치에 존재하고 있습니다.");
        } else {
          alert("잘못된 요청입니다.");
        }
      }
    },
  },
};
</script>

<style></style>
