<template>
  <div class="friends-state-list-container">
    <div class="large-searchbar-cotainer">
      <div class="large-searchbar-inner">
        <input class="large-searchbar-input" placeholder="검색하기" />
        <div class="searchicon-wrapper">
          <svg class="primary-close"></svg>
        </div>
      </div>
    </div>
    <div
      class="friends-state-list auto-scrollbar"
      role="list"
      tabindex="0"
      data-list-id="people"
    >
      <template v-if="friendsStateMenu === 'online'">
        <friends-form :friend="friendsOnline">
          <template slot="title">온라인-{{ friendsOnline.length }}명</template>
          <template slot="status"><span>온라인</span></template>
          <template v-slot:action="slotProps">
            <div
              class="action-button"
              aria-label="메시지 보내기"
              role="button"
              @click="sendDirectMessage(slotProps.userId)"
            >
              <svg class="send-message"></svg>
            </div>
            <div
              :data-key="slotProps.id"
              ref="plusAction"
              class="action-button"
              aria-label="기타"
              role="button"
              @click="clickPlusAction($event, slotProps)"
            >
              <svg class="plus-action"></svg>
            </div>
          </template>
        </friends-form>
      </template>
      <template v-else-if="friendsStateMenu === 'all'">
        <friends-form :friend="friendsAccept">
          <template slot="title"
            >모든친구-{{ friendsAccept.length }}명</template
          >
          <template v-slot:action="slotProps">
            <div
              class="action-button"
              aria-label="메시지 보내기"
              role="button"
              @click="sendDirectMessage(slotProps.userId)"
            >
              <svg class="send-message"></svg>
            </div>
            <div
              :data-key="slotProps.id"
              ref="plusAction"
              class="action-button"
              aria-label="기타"
              role="button"
              @click="clickPlusAction($event, slotProps)"
            >
              <svg class="plus-action"></svg>
            </div>
          </template>
        </friends-form>
      </template>
      <template v-else-if="friendsStateMenu === 'waiting'">
        <friends-form :friend="friendsWait">
          <template slot="title">
            대기중-{{ friendsWaitNumber + friendsRequest.length }}명
          </template>
          <template slot="status"><span>받은 친구 요청</span></template>
          <template v-slot:action="slotProps">
            <div
              class="action-button"
              aria-label="수락"
              role="button"
              @click="accept(slotProps.id)"
            >
              <svg class="done"></svg>
            </div>
            <div
              class="action-button"
              aria-label="거절"
              role="button"
              @click="rejectFriend(slotProps.id)"
            >
              <svg class="primary-close"></svg>
            </div>
          </template>
        </friends-form>
        <friends-form :friend="friendsRequest">
          <template slot="status"><span>보낸 친구 요청</span></template>
          <template v-slot:action="slotProps">
            <div
              class="action-button"
              aria-label="취소"
              role="button"
              @click="rejectFriend(slotProps.id)"
            >
              <svg class="primary-close"></svg>
            </div>
          </template>
        </friends-form>
      </template>
      <template v-else-if="friendsStateMenu === 'blockedlist'">
        <friends-form :friend="friendsBan">
          <template slot="title">차단-{{ friendsBan.length }}명</template>
          <template slot="status"><span>차단 목록</span></template>
          <template v-slot:action="slotProps">
            <div
              class="action-button"
              aria-label="차단해제"
              role="button"
              @click="rejectFriend(slotProps.id)"
            >
              <svg class="blocked"></svg>
            </div>
          </template>
        </friends-form>
      </template>
    </div>
  </div>
</template>

<script>
import { mapState, mapMutations } from "vuex";
import FriendsForm from "./FriendsForm.vue";
import { acceptFriend, deleteFriend } from "../../api/index.js";
import { sendDirectMessage } from "@/utils/common";

export default {
  components: { FriendsForm },

  mounted() {
    window.addEventListener("click", this.onClick);
  },
  computed: {
    ...mapState("friends", [
      "friendsStateMenu",
      "friendsOnline",
      "friendsAccept",
      "friendsWait",
      "friendsWaitNumber",
      "friendsRequest",
      "friendsBan",
      "friendsPlusMenu",
    ]),
    ...mapState("dm", ["directMessageList"]),
  },
  methods: {
    ...mapMutations("utils", ["setClientX", "setClientY"]),
    ...mapMutations("friends", ["setFriendsPlusMenu"]),
    async accept(id) {
      try {
        await acceptFriend(id);
        window.location.reload();
      } catch (err) {
        console.log(err);
      }
    },
    //친구 추가 기능을 보여주기 위해 마우스 좌표를 저장한다.
    clickPlusAction(event, userInfo) {
      console.log(event.clientX, event.clientY, userInfo);
      const x = event.clientX;
      const y = event.clientY;
      this.setClientX(x);
      this.setClientY(y);
      this.setFriendsPlusMenu(userInfo);
    },
    //추가 기능 메뉴가 보여지고 있을때 다른 위치를 클릭하면 메뉴가 꺼진다.
    onClick(e) {
      if (this.friendsPlusMenu) {
        if (!e.target.parentNode.dataset.key) {
          this.setFriendsPlusMenu(null);
        }
      }
    },
    async rejectFriend(id) {
      await deleteFriend(id);
      window.location.reload();
    },
    //1:1 메시지를 걸었을 경우 dm방을 찾아 있을 경우 이동하고, 없을 경우 생성 후 이동한다.
    async sendDirectMessage(userId) {
      const channelid = await sendDirectMessage(this.directMessageList, userId);
      this.$router.push(`/channels/@me/${channelid}`);
    },
  },
};
</script>

<style>
.large-searchbar-cotainer {
  margin: 16px 20px 8px 30px;
  -webkit-box-flex: 0;
  flex: none;
  box-sizing: border-box;
  display: flex;
  border-radius: 4px;
  overflow: hidden;
  background-color: #202225;
}
.large-searchbar-inner {
  position: relative;
  -webkit-box-orient: horizontal;
  -webkit-box-direction: normal;
  flex-direction: row;
  flex-wrap: wrap;
  padding: 1px;
  min-width: 0;
  display: flex;
  box-sizing: border-box;
  flex: 1 1 auto;
}
.large-searchbar-input {
  font-size: 16px;
  line-height: 32px;
  height: 30px;
  padding: 0 8px;
  box-sizing: border-box;
  background: transparent;
  border: none;
  resize: none;
  -webkit-box-flex: 1;
  flex: 1;
  min-width: 48px;
  margin: 1px;
  appearance: none;
  color: #dcddde;
}
.searchicon-wrapper {
  width: 32px;
  height: 32px;
  display: flex;
  -webkit-box-pack: center;
  justify-content: center;
  -webkit-box-align: center;
  align-items: center;
  cursor: text;
}
.friends-state-list-container {
  display: flex;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  flex-direction: column;
  -webkit-box-flex: 1;
  flex: 1 1 auto;
  overflow: hidden;
}
.friends-state-list {
  overflow: hidden scroll;
  padding-right: 0px;
  padding-bottom: 8px;
  margin-top: 8px;
}
.action-button {
  margin-left: 0;
  cursor: pointer;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  color: var(--description-primary);
  background-color: #2f3136;
  display: flex;
  -webkit-box-align: center;
  align-items: center;
  -webkit-box-pack: center;
  justify-content: center;
}
.action-button:hover {
  background-color: #fff;
}
.send-message {
  display: flex;
  width: 20px;
  height: 20px;
  background-image: url("../../assets/send-message.svg");
}
.plus-action {
  display: flex;
  width: 20px;
  height: 20px;
  background-image: url("../../assets/plus-action.svg");
}
.auto-scrollbar::-webkit-scrollbar {
  width: 16px;
  height: 16px;
}
.auto-scrollbar::-webkit-scrollbar-corner {
  background-color: transparent;
}
.auto-scrollbar::-webkit-scrollbar-thumb {
  background-color: var(--dark-grey-color);
  min-height: 40px;
}
.auto-scrollbar::-webkit-scrollbar-thumb,
.auto-Ge5KZx::-webkit-scrollbar-track {
  border: 4px solid transparent;
  background-clip: padding-box;
  border-radius: 8px;
}
.auto-scrollbar::-webkit-scrollbar-thumb,
.auto-Ge5KZx::-webkit-scrollbar-track {
  border: 4px solid transparent;
  background-clip: padding-box;
  border-radius: 8px;
}
.auto-scrollbar::-webkit-scrollbar-track {
  background-color: hsl(210, calc(var(--saturation-factor, 1) * 9.8%), 20%);
}
.search-icon {
  width: 20px;
  height: 20px;
  background-image: url("../../assets/search-icon.svg");
}
.primary-close {
  width: 20px;
  height: 20px;
  background-image: url("../../assets/primary-close.svg");
}
.done {
  width: 18px;
  height: 13px;
  background-image: url("../../assets/done.svg");
}
.blocked {
  width: 20px;
  height: 20px;
  background-image: url("../../assets/blocked.svg");
}
</style>
