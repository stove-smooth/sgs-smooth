<template>
  <div>
    <nav class="nav-wrapper" aria-label="서버 사이드바.">
      <ul role="tree" tabindex="0" data-list-id="guildnav" class="tree">
        <div class="scoll-base">
          <div class="tutorial-container">
            <div class="listItem">
              <div class="selected-wrapper" v-show="true">
                <span class="selected-item"></span>
              </div>
              <div class="listItem-wrapper">
                <div class="circleIcon-button">
                  <svg class="discord-logo"></svg>
                </div>
              </div>
            </div>
          </div>
          <div class="listItem">
            <div class="guild-seperator"></div>
          </div>
          <div aria-label="서버">
            <!--서버 개수만큼 만들기.-->
            <div class="listItem">
              <div class="selected-wrapper" v-show="false">
                <span class="selected-item"></span>
              </div>
              <div class="listItem-wrapper">
                <div class="server"></div>
              </div>
            </div>
          </div>
          <div class="tutorial-container">
            <div class="listItem">
              <div claass="listItem-wrapper">
                <div class="circleIcon-button">
                  <svg class="plus-icon"></svg>
                </div>
              </div>
            </div>
          </div>
          <div class="listItem">
            <div class="guild-seperator"></div>
          </div>
        </div>
      </ul>
    </nav>
  </div>
</template>

<script>
export default {};
</script>

<style>
.nav-wrapper {
  position: relative;
  width: 72px;
  flex-shrink: 0;
  overflow: hidden;
  display: flex;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  flex-direction: column;
  background-color: #202225;
}

.tree {
  display: flex;
  height: 100%;
  padding: 0;
}

.scoll-base {
  /*   overflow: hidden scroll; */
  padding-right: 0px;
  /*user-select: none;*/
  padding: 0px 0px;
  background-color: #202225;
  /* contain: layout size;*/
  position: relative;
  box-sizing: border-box;
  min-height: 0;
  -webkit-box-flex: 1;
  flex: 1 1 auto;
}

.tutorial-container {
  position: relative;
}
.listItem {
  position: relative;
  margin: 0 0 8px;
  display: flex;
  -webkit-box-pack: center;
  justify-content: center;
  width: 72px;
}
.selected-wrapper {
  position: absolute;
  top: 0;
  left: 0;
  overflow: hidden;
  width: 8px;
  height: 48px;
  display: flex;
  -webkit-box-align: center;
  align-items: center;
  -webkit-box-pack: start;
  justify-content: flex-start;
  /*contain: layout size;*/
}
.selected-item {
  opacity: 1;
  height: 40px;
  transform: none;
  position: absolute;
  display: block;
  width: 8px;
  border-radius: 0 4px 4px 0;
  margin-left: -4px;
  background-color: #fff;
}
.listItem-wrapper {
  box-sizing: border-box;
  position: relative;
  width: 48px;
  height: 48px;
  cursor: pointer;
}
/* .home-box {
  z-index: 1;
  position: absolute;
  top: 0;
  left: 0;
  background-image: url("../assets/home-box.svg");
  width: 48px;
  height: 48px;
} */

.discord-logo {
  display: flex;
  background-image: url("../assets/discord-logo.svg");
  width: 27px;
  height: 22px;
}
.guild-seperator {
  height: 2px;
  width: 32px;
  border-radius: 1px;
  background-color: hsla(0, 0%, 100%, 0.06);
}
.server {
  background-color: white;
  width: 100%;
  height: 100%;
  border-radius: 50%;
}
.circleIcon-button {
  cursor: pointer;
  display: flex;
  -webkit-box-align: center;
  align-items: center;
  -webkit-box-pack: center;
  justify-content: center;
  box-sizing: border-box;
  width: 48px;
  height: 48px;
  border-radius: 50%;
  background-color: #36393f;
}
.plus-icon {
  display: flex;
  width: 16px;
  height: 16px;
  background-image: url("../assets/plus.svg");
}
ol,
ul {
  list-style: none;
}
</style>
