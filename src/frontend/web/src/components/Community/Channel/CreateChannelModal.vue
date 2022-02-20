<template>
  <div class="modal" v-if="createChannel">
    <div class="blurred-background" @click="closeModal"></div>
    <div class="modal-container">
      <modal @exit="closeModal">
        <template slot="header">
          <h3 class="modal-big-title no-margin-bottom">채팅 채널 만들기</h3>
          <div class="subtext text-align-center">
            : {{ createChannel.categoryName }}에 속해있음
          </div>
        </template>
        <template slot="content">
          <h5 class="label-id black-color">채널 유형</h5>
          <button
            class="select-channel-type-button"
            @click="selectChatType('TEXT')"
          >
            <div class="channel-type-wrapper">
              <svg
                v-if="isChatType === 'TEXT'"
                class="radio_button_checked"
              ></svg>
              <svg v-else class="radio_button_unchecked"></svg>
            </div>
            <svg class="big-hashtag-icon"></svg>
            <div class="flex-direction-column padding-left-10px">
              <div class="action-title align-self-flex-start">채팅 채널</div>
              <div class="small-title-text">
                이미지, 스티커, 의견, 농담을 올려보세요.
              </div>
            </div>
          </button>
          <button
            class="select-channel-type-button"
            @click="selectChatType('VOICE')"
          >
            <div class="channel-type-wrapper">
              <svg
                v-if="isChatType === 'VOICE'"
                class="radio_button_checked"
              ></svg>
              <svg v-else class="radio_button_unchecked"></svg>
            </div>
            <svg class="big-voice-channel"></svg>
            <div class="flex-direction-column padding-left-10px">
              <div class="action-title align-self-flex-start">음성 채널</div>
              <div class="small-title-text">
                이미지, 스티커, 의견, 농담을 올려보세요.
              </div>
            </div>
          </button>
          <form>
            <div class="server-name-input-container">
              <h5 class="label-id black-color">채널 이름</h5>
              <div class="friends-state-text position-relative">
                <svg
                  v-if="isChatType === 'TEXT'"
                  class="hashtag-icon channel-input-prefix"
                ></svg>
                <svg v-else class="voice-channel channel-input-prefix"></svg>

                <input
                  width="100%"
                  type="text"
                  placeholder="새로운 채널"
                  maxlength="100"
                  v-model="channelName"
                  class="channel-name-input"
                />
              </div>
            </div>
          </form>
        </template>
        <template slot="footer">
          <div class="submit-server-form-footer">
            <button
              :disabled="!channelName"
              type="button"
              class="medium-submit-button"
              @click="createNewChannel(createChannel)"
            >
              <div>채널 만들기</div>
            </button>
            <button class="back-button" @click="closeModal" type="button">
              취소
            </button>
          </div>
        </template>
      </modal>
    </div>
  </div>
</template>

<script>
import { createNewChannel } from "../../../api/index.js";
import { mapState, mapMutations } from "vuex";
import Modal from "../../common/Modal.vue";
export default {
  components: {
    Modal,
  },
  data() {
    return {
      isChatType: "TEXT",
      channelName: "",
    };
  },
  computed: {
    ...mapState("community", ["createChannel", "communityInfo"]),
  },
  methods: {
    ...mapMutations("community", ["setCreateChannel", "setCommunityInfo"]),
    closeModal() {
      this.setCreateChannel(false);
    },
    selectChatType(chatType) {
      this.isChatType = chatType;
    },
    async createNewChannel(categoryInfo) {
      const newChannelData = {
        id: categoryInfo.categoryId,
        name: this.channelName,
        type: this.isChatType,
        public: true,
      };
      const result = await createNewChannel(newChannelData);
      for (let i = 0; i < this.communityInfo.categories.length; i++) {
        if (
          this.communityInfo.categories[i].id == result.data.result.categoryId
        ) {
          if (this.communityInfo.categories[i].channels == null) {
            let array = [];
            array.push(result.data.result);
            this.communityInfo.categories[i].channels = array;
          } else {
            this.communityInfo.categories[i].channels.unshift(
              result.data.result
            );
          }
          await this.setCommunityInfo(this.communityInfo);
          this.setCreateChannel(false);
          if (result.data.result.type != "VOICE") {
            this.$router.push(
              "/channels/" +
                this.$route.params.serverid +
                "/" +
                result.data.result.id
            );
          }
          return;
        }
      }
    },
  },
};
</script>

<style scoped>
.radio_button_checked {
  display: flex;
  width: 24px;
  height: 24px;
  background-image: url("../../../assets/radio_button_checked.svg");
}
.radio_button_unchecked {
  width: 20px;
  height: 20px;
  background-image: url("../../../assets/radio_button_unchecked.svg");
}
.select-channel-type-button {
  border-radius: 8px;
  border: 1px solid rgba(6, 6, 7, 0.08);
  background-color: var(--white-color);
  margin-bottom: 8px;
  display: flex;
  -webkit-box-align: center;
  align-items: center;
  cursor: pointer;
  width: 100%;
  padding: 10px;
}
.big-hashtag-icon {
  display: flex;
  width: 24px;
  height: 24px;
  background-image: url("../../../assets/big-hashtag.svg");
}
.big-voice-channel {
  display: flex;
  width: 24px;
  height: 24px;
  background-image: url("../../../assets/big-voice-channel.svg");
}
.channel-name-input {
  padding-left: 28px !important;
  padding: 10px;
  height: 40px;
  font-size: 16px;
  box-sizing: border-box;
  width: 100%;
  border-radius: 3px;

  border: 1px solid rgba(0, 0, 0, 0.3);
  transition: border-color 0.2s ease-in-out;
}
.channel-input-prefix {
  position: absolute;
  top: 12px;
  left: 8px;
  color: #dcddde;
}
.lock {
  width: 16px;
  height: 16px;
  background-image: url("../../../assets/lock.svg");
}
.margin-top-eightpx {
  margin-top: 8px;
}
.align-self-flex-start {
  align-self: flex-start;
}
.channel-type-wrapper {
  width: 24px;
  padding: 10px;
}
</style>
