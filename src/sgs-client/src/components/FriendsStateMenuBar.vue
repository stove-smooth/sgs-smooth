<template>
  <div>
    <section class="friends-state-menu-container">
      <div class="friends-state-menu">
        <div class="friends-icon-wrapper">
          <svg class="friends-icon"></svg>
        </div>
        <h3 class="friends-section-title description">친구</h3>
        <div class="divider"></div>
        <div
          class="friends-tabbar"
          role="tablelist"
          aria-orientation="horiaontal"
          aria-lable="친구"
        >
          <div
            class="friends-tab-decorator"
            role="tab"
            aria-controls="online-tab"
            tabindex="0"
          >
            온라인
          </div>
          <div
            class="friends-tab-decorator"
            role="tab"
            aria-controls="all-tab"
            tabindex="-1"
          >
            모두
          </div>
          <div
            class="friends-tab-decorator"
            role="tab"
            aria-controls="pending-tab"
            tabindex="-1"
          >
            대기 중
          </div>
          <div
            class="friends-tab-decorator"
            role="tab"
            aria-controls="blocked-tab"
            tabindex="-1"
          >
            차단 목록
          </div>
          <div class="friends-tab-decorator add-friends-button">
            <span>친구 추가하기</span>
          </div>
        </div>
      </div>
      <div class="message-toolbar">
        <div class="invite-toolbar">
          <div
            class="message-toolbar-icon"
            role="button"
            aria-label="새로운 그룹 메시지"
          >
            <svg class="invite-icon"></svg>
          </div>
          <div class="divider"></div>
        </div>
        <div
          class="message-toolbar-icon"
          role="button"
          aria-label="받은 편지함"
        >
          <svg class="mail-box"></svg>
        </div>
      </div>
    </section>
    <div class="friends-state-list-container">
      <div
        class="friends-state-list"
        role="list"
        tabindex="0"
        data-list-id="people"
      >
        <div>
          <h2 class="number-of-friends-container small-title-text">
            온라인-7명
          </h2>
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
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {};
</script>

<style>
.friends-state-menu-container {
  background: #36393f;
  box-sizing: border-box;
  position: relative;
  /* display: -webkit-box;
    display: -ms-flexbox; */
  display: flex;
  -webkit-box-align: center;
  /* -ms-flex-align: center; */
  align-items: center;
  min-width: 0;
  width: 100%;
  -webkit-box-flex: 0;
  /* -ms-flex: 0 0 auto; */
  flex: 0 0 auto;
  height: 48px;
  padding: 0 8px;
  font-size: 16px;
  line-height: 20px;
  cursor: default;
  z-index: 2;
  color: #dcddde;
}
.friends-state-menu {
  position: relative;
  -webkit-box-flex: 1;
  /* -ms-flex: 1 1 auto; */
  flex: 1 1 auto;
  /* display: -webkit-box;
  display: -ms-flexbox; */
  display: flex;
  -webkit-box-align: center;
  /* -ms-flex-align: center; */
  align-items: center;
  min-width: 0;
  overflow: hidden;
}
.friends-icon-wrapper {
  position: relative;
  height: 24px;
  width: auto;
  -webkit-box-flex: 0;
  /* -ms-flex: 0 0 auto; */
  flex: 0 0 auto;
  margin: 0 8px;
}
.friends-section-title {
  -webkit-box-pack: start;
  /* -ms-flex-pack: start; */
  justify-content: flex-start;
  margin: 0 8px 0 0;
  /* -ms-flex: 0 0 auto; */
  flex: 0 0 auto;
  min-width: auto;
  overflow: hidden;
  white-space: nowrap;

  -webkit-box-flex: 0;
  /*  display: -webkit-box;
  display: -ms-flexbox; */
  display: flex;
  -webkit-box-align: center;
  /* -ms-flex-align: center; */
  align-items: center;
  box-sizing: border-box;
  color: #fff;
}
.divider {
  width: 1px;
  height: 24px;
  margin: 0 8px;
  -webkit-box-flex: 0;
  /* -ms-flex: 0 0 auto; */
  flex: 0 0 auto;
  background: hsla(0, 0%, 100%, 0.06);
}
.friends-tabbar {
  /* display: -webkit-box;
  display: -ms-flexbox; */
  display: flex;
  -webkit-box-orient: horizontal;
  -webkit-box-direction: normal;
  /* -ms-flex-direction: row; */
  flex-direction: row;
}
.friends-tab-decorator {
  display: flex;
  -webkit-box-pack: center;
  /* -ms-flex-pack: center; */
  justify-content: center;
  -webkit-box-align: center;
  /* -ms-flex-align: center; */
  align-items: center;
  text-align: center;
  min-width: 40px;
  -webkit-app-region: no-drag;
  border-radius: 4px;
  margin: 0 8px;
  padding: 2px 8px;
  color: #b9bbbe;
  position: relative;
  font-size: 16px;
  line-height: 20px;
  cursor: pointer;
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
  /* -ms-flex-negative: 0; */
  flex-shrink: 0;
  font-weight: 500;
}
.friends-tab-decorator:hover {
  background-color: rgb(47 49 54);
  cursor: default;
  color: #fff;
}
.friends-tab-decorator:active {
  background-color: rgb(47 49 54);
  cursor: default;
  color: #fff;
}
.friends-tab-decorator:visited {
  background-color: rgb(47 49 54);
  cursor: default;
  color: #fff;
}
.add-friends-button {
  color: hsl(0, calc(var(--saturation-factor, 1) * 0%), 100%);
  background-color: hsl(139, calc(var(--saturation-factor, 1) * 47.3%), 43.9%);
}
.message-toolbar {
  -webkit-box-flex: 0;
  /* display: -webkit-box;
  display: -ms-flexbox; */
  display: flex;
  -webkit-box-align: center;
  /* -ms-flex-align: center; */
  align-items: center;
  flex: 0 0 auto;
  min-width: 0;
}
.invite-toolbar {
  display: flex;
}
@media (max-width: 940px) {
  .invite-toolbar {
    display: none;
  }
}
.message-toolbar-icon {
  position: relative;
  height: 24px;
  width: auto;
  -webkit-box-flex: 0;
  /* -ms-flex: 0 0 auto; */
  flex: 0 0 auto;
  margin: 0 8px;
  cursor: pointer;
}
.invite-icon {
  display: flex;
  width: 24px;
  height: 24px;
  background-image: url("../assets/invite-group-message.svg");
}
.mail-box {
  display: flex;
  width: 24px;
  height: 24px;
  background-image: url("../assets/mail-box.svg");
}
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
</style>
