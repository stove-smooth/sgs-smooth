<template>
  <div v-show="createServer" class="modal">
    <div class="blurred-background" @click="exitCreate"></div>
    <div class="modal-container">
      <template v-if="progress === 'openCreate'">
        <modal @exit="exitCreate">
          <template slot="header">
            <h3 class="modal-big-title">서버 만들기</h3>
            <div class="modal-subtitle">
              서버는 나와 친구들이 함께 어울리는 공간입니다. 내 서버를 만들고
              대화를 시작해보세요.
            </div>
          </template>
          <template slot="content">
            <button class="create-server-button" @click="openSelectServer">
              <svg class="create-server-image-wrapper"></svg>
              <div class="action-title">직접 만들기</div>
              <svg class="right-arrow"></svg>
            </button>
          </template>
          <template slot="footer">
            <div class="create-server-form-footer">
              <h3 class="footer-title">이미 초대장을 받으셨나요?</h3>
              <button class="grey-large-button" type="button">
                <div>서버 참가하기</div>
              </button>
            </div>
          </template>
        </modal>
      </template>
      <template v-else-if="progress === 'openSelect'">
        <modal @exit="exitCreate">
          <template slot="header">
            <h3 class="modal-big-title">
              이 서버에 대해 더 자세히 말해주세요.
            </h3>
            <div class="modal-subtitle">
              설정을 돕고자 질문을 드려요. 혹시 서버가 친구 몇 명만을 위한
              서버인가요, 아니면 더 큰 커뮤니티를 위한 서버인가요?
            </div>
          </template>
          <template slot="content">
            <button
              class="create-server-button"
              @click="openFinalSelect(false)"
            >
              <svg class="private-server"></svg>
              <div class="action-title">나와 친구들을 위한 서버</div>
              <svg class="right-arrow"></svg>
            </button>
            <button class="create-server-button" @click="openFinalSelect(true)">
              <svg class="public-server"></svg>
              <div class="action-title">클럽 혹은 파티용 서버</div>
              <svg class="right-arrow"></svg>
            </button>
          </template>
          <template slot="footer">
            <div class="create-server-form-footer">
              <button class="back-button" @click="goBackCreate">
                뒤로 가기
              </button>
            </div>
          </template>
        </modal>
      </template>
      <template v-else>
        <modal @exit="exitCreate">
          <template slot="header">
            <h3 class="modal-big-title">서버 커스터마이징 하기</h3>
            <div class="modal-subtitle">
              새로운 서버에 이름과 아이콘을 부여해 개성을 드러내보세요. 나중에
              언제든 바꿀 수 있어요.
            </div>
          </template>
          <template slot="content">
            <div class="upload-server-image-wrapper">
              <div class="upload-server-image-icon">
                <template v-if="thumbnail">
                  <img :src="thumbnail" alt="image" class="server-image" />
                </template>
                <template v-else>
                  <svg class="upload-image"></svg>
                </template>
                <input
                  class="file-input"
                  type="file"
                  ref="image"
                  accept="image/*"
                  @change="uploadImage()"
                />
              </div>
            </div>
            <div>
              <div class="server-name-input-container">
                <div class="server-name-label">서버 이름</div>
                <div class="flex-direction-column">
                  <input
                    class="server-name-input"
                    type="text"
                    placeholder="serverName"
                    maxlength="100"
                    v-model="serverName"
                  />
                </div>
              </div>
            </div>
          </template>
          <template slot="footer">
            <div class="submit-server-form-footer">
              <button
                :disabled="!serverName"
                type="button"
                class="medium-submit-button"
                @click="createNewServer"
              >
                <div>만들기</div>
              </button>
              <button class="back-button" @click="goBackSelect">
                뒤로 가기
              </button>
            </div>
          </template>
        </modal>
      </template>
    </div>
  </div>
</template>

<script>
import Modal from "../components/common/Modal.vue";
import { converToThumbnail, dataUrlToFile } from "../utils/common.js";
import { mapState, mapMutations } from "vuex";
import { createNewCommunity } from "../api/index.js";
export default {
  components: {
    Modal,
  },
  data() {
    return {
      isPublic: false,
      serverName: "새로운 서버",
      progress: "openCreate",
      thumbnail: "",
    };
  },
  computed: {
    ...mapState("server", ["createServer"]),
  },
  methods: {
    ...mapMutations("server", ["setCreateServer"]),
    openSelectServer() {
      this.progress = "openSelect";
    },
    goBackCreate() {
      this.progress = "openCreate";
    },
    goBackSelect() {
      this.progress = "openSelect";
    },
    openFinalSelect(isPublic) {
      console.log("누름", isPublic);
      this.progress = "finalSelect";
      this.isPublic = isPublic;
    },
    async uploadImage() {
      let image = this.$refs["image"].files[0];
      console.log("image", image);
      this.thumbnail = await converToThumbnail(image);
    },
    async createNewServer() {
      if (!this.thumbnail) {
        let frm = new FormData();
        frm.append("name", this.serverName);
        frm.append("public", this.isPublic);
        await createNewCommunity(frm);
      } else {
        const file = await dataUrlToFile(this.thumbnail);
        let frm = new FormData();
        frm.append("icon", file);
        frm.append("name", this.serverName);
        frm.append("public", this.isPublic);
        await createNewCommunity(frm);
      }
      window.location.reload();
    },
    exitCreate() {
      this.setCreateServer(false);
      this.thumbnail = "";
      this.progress = "openCreate";
      this.isPublic = false;
      this.serverName = "밍디님의 서버";
    },
  },
};
</script>

<style>
.create-server-button {
  border-radius: 8px;
  border: 1px solid rgba(6, 6, 7, 0.08);
  background-color: var(--white-color);
  margin-bottom: 8px;
  display: flex;
  -webkit-box-align: center;
  align-items: center;
  cursor: pointer;
  width: 100%;
  padding: 0;
}
.create-server-image-wrapper {
  margin: 8px 8px 8px 16px;
  width: 32px;
  height: 32px;
  background-image: url("../assets/create-icon.svg");
}
.action-title {
  font-weight: 700;
  overflow: hidden;
  text-overflow: ellipsis;
  font-size: 16px;
  line-height: 20px;
  color: #2e3338;
}
.right-arrow {
  margin-left: auto;
  margin-right: 16px;
  width: 16px;
  height: 16px;
  background-image: url("../assets/right-arrow.svg");
}
.create-server-form-footer {
  background-color: #f6f6f7;
  flex-direction: column;
  align-items: center;
  border-radius: 0 0 5px 5px;
  padding: 0px 16px 16px 16px;
  display: flex;
}
.footer-title {
  margin-bottom: 8px;
  font-weight: 600;
  color: #060607;
  font-size: 20px;
  line-height: 24px;
}
.grey-large-button {
  color: var(--white-color);
  background-color: #747f8d !important;
  align-self: stretch;
  width: auto;
  height: 38px;
  min-width: 96px;
  min-height: 38px;
  position: relative;
  display: flex;
  -webkit-box-pack: center;
  justify-content: center;
  -webkit-box-align: center;
  align-items: center;
  box-sizing: border-box;
  background: none;
  border: none;
  border-radius: 3px;
  font-size: 14px;
  font-weight: 500;
  line-height: 16px;
  padding: 2px 16px;
  user-select: none;
}
.back-button {
  height: 38px;
  margin-right: auto;
  width: auto;
  display: line;
  padding: 2px 4px;
  border: 0;
  background-color: #f6f6f7;
}
.private-server {
  width: 48px;
  height: 48px;
  background-image: url("../assets/private-server.svg");
}
.public-server {
  width: 48px;
  height: 48px;
  background-image: url("../assets/public-server.svg");
}
.upload-server-image-wrapper {
  padding-top: 4px;
  display: flex;
  -webkit-box-pack: center;
  justify-content: center;
  color: #4f5660;
}
.upload-server-image-icon {
  height: 80px;
  position: relative;
  width: 80px;
}
.upload-image {
  width: 80px;
  height: 80px;
  background-image: url("../assets/upload-image.svg");
}
.server-name-input-container {
  margin-top: 24px;
}
.server-name-label {
  color: #4f5660;
  margin-bottom: 8px;
  font-size: 12px;
  line-height: 16px;
  font-weight: 600;
}
.server-name-input {
  padding: 10px;
  height: 40px;
  font-size: 16px;
  box-sizing: border-box;
  width: 100%;
  border-radius: 3px;
  color: var(--text-normal);
  background-color: rgba(79, 84, 92, 0.02);
  border: 1px solid rgba(79, 84, 92, 0.3);
}
.submit-server-form-footer {
  display: flex;
  align-items: stretch;
  justify-content: space-between;
  flex-wrap: nowrap;
  flex-direction: row-reverse;
  position: relative;
  -webkit-box-flex: 0;
  padding: 16px;
  z-index: 1;
  overflow-x: hidden;
  border-radius: 0 0 5px 5px;
  background-color: #f6f6f7;
}
.medium-submit-button {
  color: var(--white-color);
  background-color: var(--discord-primary) !important;
  height: 38px;
  min-width: 96px;
  min-height: 38px;
  position: relative;
  display: flex;
  -webkit-box-pack: center;
  justify-content: center;
  -webkit-box-align: center;
  align-items: center;
  box-sizing: border-box;
  background: none;
  border: none;
  border-radius: 3px;
  font-size: 14px;
  font-weight: 500;
  line-height: 16px;
  padding: 2px 16px;
}
.medium-submit-button:disabled {
  cursor: default;
  opacity: 0.5;
}
.server-image {
  height: 80px;
  width: 80px;
  border-radius: 50%;
}
</style>
