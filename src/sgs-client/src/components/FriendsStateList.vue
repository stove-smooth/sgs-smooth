<template>
  <div class="friends-state-list-container">
    <div
      class="friends-state-list auto-scrollbar"
      role="list"
      tabindex="0"
      data-list-id="people"
    >
      <div>
        <h2 class="number-of-friends-container small-title-text">온라인-7명</h2>
        <div v-for="(item, index) in friends" :key="index">
          <div class="firends-list-item" role="listitem" tabindex="-1">
            <div class="friends-list-item-contents">
              <div class="friends-state-info">
                <div class="profile-margin profile-wrapper">
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
                <div class="friends-state-text">
                  <div class="discord-name-tag">
                    <span class="bold-username">{{ item.name }}</span>
                    <span class="user-code">#5332</span>
                  </div>
                  <div class="status-description">
                    <div class="status-subtext">온라인</div>
                  </div>
                </div>
              </div>
              <div class="action-to-friends">
                <div
                  class="action-button"
                  aria-label="메시지 보내기"
                  role="button"
                >
                  <svg class="send-message"></svg>
                </div>
                <div class="action-button" aria-label="기타" role="button">
                  <svg class="plus-action"></svg>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      friends: [
        { name: "두리짱" },
        { name: "병각" },
        { name: "히동" },
        { name: "두리짱" },
        { name: "병각" },
        { name: "히동" },
        { name: "두리짱" },
        { name: "병각" },
        { name: "히동" },
        { name: "두리짱" },
        { name: "병각" },
        { name: "히동" },
        { name: "두리짱" },
        { name: "병각" },
        { name: "히동" },
        { name: "두리짱" },
        { name: "병각" },
        { name: "히동" },
        { name: "두리짱" },
        { name: "병각" },
        { name: "히동" },
        { name: "두리짱" },
        { name: "병각" },
        { name: "히동" },
      ],
    };
  },
};
</script>

<style>
.friends-state-list-container {
  display: flex;
  height: 100%;
  -webkit-box-orient: horizontal;
  -webkit-box-direction: normal;
  /* -ms-flex-direction: row; */
  flex-direction: row;
  position: relative;
  overflow: hidden;
  /* -webkit-transform: translateZ(0); */
  transform: translateZ(0);
}
.friends-state-list {
  overflow: hidden scroll;
  padding-right: 0px;
  padding-bottom: 8px;
  margin-top: 8px;
}
.number-of-friends-container {
  margin: 16px 20px 8px 30px;
  color: #b9bbbe;
}
.firends-list-item {
  height: 62px;
  opacity: 1;
  /* display: -webkit-box;
  display: -ms-flexbox; */
  display: flex;
  -webkit-box-orient: horizontal;
  -webkit-box-direction: normal;
  /* -ms-flex-direction: row; */
  flex-direction: row;
  margin-left: 30px;
  margin-right: 20px;
  font-weight: 500;
  font-size: 16px;
  line-height: 20px;
  overflow: hidden;
  /* -webkit-box-sizing: border-box; */
  box-sizing: border-box;
  cursor: pointer;
  border-top: 1px solid hsla(0, 0%, 100%, 0.06);
}
.friends-list-item-contents {
  display: flex;
  -webkit-box-flex: 1;
  /* -ms-flex-positive: 1; */
  flex-grow: 1;
  -webkit-box-align: center;
  /* -ms-flex-align: center; */
  align-items: center;
  -webkit-box-pack: justify;
  /* -ms-flex-pack: justify; */
  justify-content: space-between;
  max-width: 100%;
}
.friends-state-info {
  display: flex;
  overflow: hidden;
}
.profile-margin {
  margin: 0 12px 0 0;
  /* -ms-flex-negative: 0; */
  flex-shrink: 0;
}
.friends-state-text {
  /* display: -webkit-box;
  display: -ms-flexbox; */
  display: flex;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  /* -ms-flex-direction: column; */
  flex-direction: column;
  overflow: hidden;
}

.discord-name-tag {
  display: flex;
  overflow: hidden;
  -webkit-box-flex: 1;
  /* -ms-flex-positive: 1; */
  flex-grow: 1;
  -webkit-box-align: end;
  /* -ms-flex-align: end; */
  align-items: flex-end;
  -webkit-box-pack: start;
  justify-content: flex-start;
  line-height: 1.1;
}
.bold-username {
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
  color: #fff;
  font-weight: 600;
  -webkit-box-flex: 0;
  display: block;
  flex: 0 1 auto;
}
.user-code {
  font-size: 14px;
  line-height: 16px;
  color: #b9bbbe;
}
.status-description {
  color: #b9bbbe;
  font-size: 12px;
}
.status-subtext {
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
  font-size: 14px;
}
.action-to-friends {
  margin-left: 8px;
  display: flex;
}
.action-button {
  margin-left: 0;
  cursor: pointer;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  color: #b9bbbe;
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
  background-color: #202225;
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
</style>
