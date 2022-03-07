<template>
  <div class="modal" v-if="communityReadyToBanish">
    <div class="blurred-background" @click="exitModal"></div>
    <div class="modal-container">
      <modal @exit="exitModal">
        <template slot="header">
          <h3 class="modal-big-title">
            {{ communityReadyToBanish.nickname }}님을 추방하기
          </h3>
        </template>
        <template slot="content">
          <div class="modal-subtitle">
            정말로 {{ communityReadyToBanish.nickname }}님을 추방하시겠어요? 새
            초대를 받으면 다시 참가할 수 있어요.
          </div>
        </template>
        <template slot="footer">
          <div class="submit-server-form-footer">
            <button
              type="button"
              class="medium-submit-button"
              @click="banishCommunity()"
            >
              <div>추방하기</div>
            </button>
            <button class="back-button" @click="exitModal">취소</button>
          </div>
        </template>
      </modal>
    </div>
  </div>
</template>

<script>
import Modal from "@/components/common/Modal.vue";
import { mapState, mapMutations } from "vuex";
import { exitCommunity } from "@/api";
export default {
  components: { Modal },
  computed: {
    ...mapState("community", [
      "communityReadyToBanish",
      "communityOnlineMemberList",
      "communityOfflineMemberList",
    ]),
  },
  methods: {
    ...mapMutations("community", [
      "setCommunityReadyToBanish",
      "setCommunityOnlineMemberList",
      "setCommunityOfflineMemberList",
    ]),
    exitModal() {
      this.setCommunityReadyToBanish(false);
    },
    async banishCommunity() {
      try {
        await exitCommunity(
          this.$route.params.serverid,
          this.communityReadyToBanish.id
        );

        let array = this.communityOnlineMemberList.filter(
          (element) => element.id !== this.communityReadyToBanish.id
        );
        this.setCommunityOnlineMemberList(array);
        let array2 = this.communityOfflineMemberList.filter(
          (element) => element.id !== this.communityReadyToBanish.id
        );
        this.setCommunityOfflineMemberList(array2);
        this.setCommunityReadyToBanish(false);
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
