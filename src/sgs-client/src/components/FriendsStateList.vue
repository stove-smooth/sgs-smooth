<template>
  <div class="friends-state-list-container">
    <div class="large-searchbar-cotainer">
      <div class="large-searchbar-inner">
        <input class="large-searchbar-input" placeholder="검색하기" />
        <div class="searchicon-wrapper">
          <!-- <svg class="search-icon"></svg> -->
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
      <template v-if="$store.state.friendsstatemenu === 'online'">
        <friends-form :friend="list">
          <template slot="title">온라인-3명</template>
          <template slot="action">
            <div class="action-button" aria-label="메시지 보내기" role="button">
              <svg class="send-message"></svg>
            </div>
            <div class="action-button" aria-label="기타" role="button">
              <svg class="plus-action"></svg>
            </div>
          </template>
        </friends-form>
      </template>
      <template v-else-if="$store.state.friendsstatemenu === 'all'">
        <friends-form :friend="list">
          <template slot="title">모든친구-3명</template>
          <template slot="action">
            <div class="action-button" aria-label="메시지 보내기" role="button">
              <svg class="send-message"></svg>
            </div>
            <div class="action-button" aria-label="기타" role="button">
              <svg class="plus-action"></svg>
            </div>
          </template>
        </friends-form>
      </template>
      <template v-else-if="$store.state.friendsstatemenu === 'waiting'">
        <friends-form :friend="friendswaiting">
          <template slot="title">대기중-3명</template>
          <template slot="action">
            <div class="action-button" aria-label="메시지 보내기" role="button">
              <svg class="done"></svg>
            </div>
            <div class="action-button" aria-label="기타" role="button">
              <svg class="primary-close"></svg>
            </div>
          </template>
        </friends-form>
      </template>
      <template v-else-if="$store.state.friendsstatemenu === 'blockedlist'">
        <friends-form :friend="list">
          <template slot="title">차단-3명</template>
          <template slot="action">
            <div class="action-button" aria-label="메시지 보내기" role="button">
              <svg class="blocked"></svg>
            </div>
          </template>
        </friends-form>
      </template>
    </div>
  </div>
</template>

<script>
import FriendsForm from "./common/FriendsForm.vue";
export default {
  components: { FriendsForm },
  data() {
    return {
      list: [
        { id: 0, name: "두리짱" },
        { id: 1, name: "병각" },
        { id: 2, name: "히동" },
        { id: 3, name: "두리짱" },
        { id: 4, name: "병각" },
        { id: 5, name: "히동" },
        { id: 6, name: "두리짱" },
        { id: 7, name: "병각" },
        { id: 8, name: "히동" },
        { id: 9, name: "두리짱" },
        { id: 10, name: "병각" },
      ],
    };
  },
  created() {
    this.$store.dispatch("FETCH_FRIENDSWAITING");
  },
  computed: {
    friendswaiting() {
      return this.$store.state.friendswaiting;
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
  /* -ms-flex-direction: column; */
  flex-direction: column;
  -webkit-box-flex: 1;
  /* -ms-flex: 1 1 auto; */
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
  /* display: -webkit-box;
  display: -ms-flexbox; */
  display: flex;
  -webkit-box-align: center;
  /* -ms-flex-align: center; */
  align-items: center;
  -webkit-box-pack: center;
  /*  -ms-flex-pack: center; */
  justify-content: center;
  /* margin-left: 10px; */
}
.send-message {
  display: flex;
  width: 20px;
  height: 20px;
  background-image: url("../assets/send-message.svg");
}
.plus-action {
  display: flex;
  width: 20px;
  height: 20px;
  background-image: url("../assets/plus-action.svg");
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
  background-image: url("../assets/search-icon.svg");
}
.primary-close {
  width: 20px;
  height: 20px;
  background-image: url("../assets/primary-close.svg");
}
.done {
  width: 18px;
  height: 13px;
  background-image: url("../assets/done.svg");
}
.blocked {
  width: 20px;
  height: 20px;
  background-image: url("../assets/blocked.svg");
}
</style>
