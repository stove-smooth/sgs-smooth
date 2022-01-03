<template>
  <div class="private-channels">
    <div class="searchbar-container">
      <button class="searchbar">대화 찾기 또는 시작하기</button>
    </div>
    <div class="thin-scrollbar dm-scroller">
      <div class="dm-content">
        <div class="dm-channel">
          <div class="dm-layout">
            <div class="avatar-container">
              <svg class="friends-icon"></svg>
            </div>
            <div class="friends-contents">
              <div class="friends-name-decorator">
                <div class="friends-name">친구</div>
              </div>
            </div>
          </div>
        </div>
        <h2 class="private-channels-header-container small-title-text">
          <span class="private-channels-header-text">다이렉트 메시지</span>
          <div class="invite-private-channels-button" aria-label="DM생성">
            <svg class="invite-private-channels-icon"></svg>
          </div>
        </h2>
        <DMListForm></DMListForm>
      </div>
    </div>
  </div>
</template>

<script>
import DMListForm from "./DMListForm.vue";
export default {
  components: { DMListForm },
};
</script>

<style>
.private-channels {
  /*   -webkit-box-sizing: border-box; */
  box-sizing: border-box;
  overflow: hidden;
  /*   -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none; */
  user-select: none;
  -webkit-box-flex: 1;
  /*   -ms-flex: 1; */
  flex: 1;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  /*   -ms-flex-direction: column; */
  flex-direction: column;
  background-color: #2f3136;
  position: relative;
  /*   display: -webkit-box;
  display: -ms-flexbox; */
  display: flex;
}
.searchbar-container {
  z-index: 2;
  -webkit-box-flex: 0;
  /*     -ms-flex: 0 0 auto; */
  flex: 0 0 auto;
  padding: 10px 10px 0px 10px;
  height: 48px;
  -webkit-box-align: center;
  /*     -ms-flex-align: center; */
  align-items: center;
  /*     -webkit-box-shadow: var(--elevation-low); */
  box-shadow: 0 1px 0 rgba(4, 4, 5, 0.2), 0 1.5px 0 rgba(6, 6, 7, 0.05),
    0 2px 0 rgba(4, 4, 5, 0.05);
}
.searchbar {
  width: 100%;
  height: 28px;
  overflow: hidden;
  border-radius: 4px;
  background-color: #202225;
  /*  -webkit-box-shadow: none; */
  box-shadow: none;
  color: #72767d;
  text-align: left;
  text-overflow: ellipsis;
  font-size: 14px;
  font-weight: 500;
  line-height: 24px;
  white-space: nowrap;
}
.dm-content {
  height: 1420px;
  position: relative;
  padding-top: 8px;
  /**padding은 임의로해봄. */
}
.dm-channel {
  position: relative;
  max-width: 224px;
  margin-left: 8px;

  /*   -webkit-box-sizing: border-box; */
  box-sizing: border-box;
  display: block;
  padding: 1px 0;
  border-radius: 4px;
  /*     -webkit-transition: none; */
  transition: none;
  color: #8e9297;
}
.dm-layout {
  /*   display: -webkit-box;
    display: -ms-flexbox; */
  display: flex;
  -webkit-box-align: center;
  /*     -ms-flex-align: center; */
  align-items: center;
  border-radius: 4px;
  height: 42px;
  padding: 0 8px;
  cursor: pointer;
}
.dm-layout:hover {
  background-color: rgb(79 84 92 / 32%);
}
.dm-layout:active {
  background-color: rgb(79 84 92 / 32%);
}
.dm-layout:visited {
  background-color: rgb(79 84 92 / 32%);
}
.avatar-container {
  /*   display: -webkit-box;
    display: -ms-flexbox; */
  display: flex;
  -webkit-box-align: center;
  /* -ms-flex-align: center; */
  align-items: center;
  -webkit-box-pack: center;
  /* -ms-flex-pack: center; */
  justify-content: center;
  -webkit-box-flex: 0;
  /* -ms-flex: 0 0 auto; */
  flex: 0 0 auto;
  width: 32px;
  height: 32px;
  margin-right: 12px;
}
.friends-icon {
  display: flex;
  width: 21px;
  height: 17px;
  background-image: url("../assets/friends.svg");
}
.friends-contents {
  /* white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden; */
  min-width: 0;
  -webkit-box-flex: 1;
  flex: 1 1 auto;
}
.friends-name-decorator {
  display: flex;
  -webkit-box-pack: start;

  justify-content: space-between;
  -webkit-box-align: center;

  align-items: center;
}
.friends-name {
  font-size: 16px;
  line-height: 20px;
  font-weight: 500;
  -webkit-box-flex: 0;
  /*     -ms-flex: 0 1 auto; */
  flex: 0 1 auto;
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
}
.private-channels-header-container {
  display: flex;
  padding: 18px 8px 4px 18px;
  height: 40px;
}

.small-title-text {
  box-sizing: border-box;
  text-overflow: ellipsis;
  white-space: nowrap;
  overflow: hidden;
  text-transform: uppercase;
  font-size: 12px;
  line-height: 16px;
  letter-spacing: 0.25px;
  font-weight: 600;
  -webkit-box-flex: 1;
  /* -ms-flex: 1 1 auto; */
  flex: 1 1 auto;
  color: #8e9297;
}

.private-channels-header-text {
  -webkit-box-flex: 1;
  /* -ms-flex: 1; */
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
}
.invite-private-channels-button {
  -webkit-box-flex: 0;
  /*  -ms-flex: 0; */
  flex: 0;
  width: 16px;
  height: 16px;
  margin-left: 0;
  margin-right: 2px;
  position: relative;
  /* height: 24px;
    width: auto;
    -webkit-box-flex: 0;
    -ms-flex: 0 0 auto;
    flex: 0 0 auto; */
  margin: 0 8px;
  cursor: pointer;
}
.invite-private-channels-icon {
  -webkit-box-flex: 0;
  /* -ms-flex: 0; */
  flex: 0;
  width: 12px;
  height: 12px;
  margin-left: 0;
  margin-right: 2px;
  background-image: url("../assets/private-channel-plus.svg");
}
.profile-wrapper {
  width: 32px;
  height: 32px;
  position: relative;
  border-radius: 50%;
}
.avatar-wrapper {
  display: relative;
  width: 100%;
  height: 100%;
}
.avatar {
  display: block;
  /* -o-object-fit: cover; */
  object-fit: cover;
  pointer-events: none;
  width: 100%;
  height: 100%;
  grid-area: 1/1;
  border-radius: 50%;
}
.subtext-decorator {
  margin-top: -2px;
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
}
.subtext {
  font-size: 12px;
  line-height: 16px;
  font-weight: 500;
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
}
/**프로필 상태 */
.status-ring {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 12px;
  height: 12px;
  /* Ring */
  position: absolute;
  bottom: 0%;
  right: 0%;
  border-radius: 50%;
  /* Dark Mode/Gray 1 */
  background: #2f3136;
  transform: rotate(90deg);
}

.status-offline {
  background-image: url("../assets/status-offline.svg");
  width: 10px;
  height: 10px;
}
.status-online {
  background-image: url("../assets/status-online.svg");
  width: 10px;
  height: 10px;
}
.status-dnd {
  background-image: url("../assets/status-dnd.svg");
  width: 10px;
  height: 10px;
}
.status-away {
  background-image: url("../assets/status-away.svg");
  width: 10x;
  height: 10px;
}
</style>
