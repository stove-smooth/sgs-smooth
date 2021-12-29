<template>
  <div>
    <nav class="nav-wrapper" aria-label="서버 사이드바.">
      <ul role="tree" tabindex="0" data-list-id="guildnav" class="tree">
        <div class="scoll-base">
          <div class="listItem">
            <div class="selected-wrapper" v-show="true" />
            <div class="listItem-wrapper">
              <img src="../assets/home-box.svg" class="home-box" />
            </div>
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
  padding: 12px 0 0;
  background-color: #202225;
  /* contain: layout size;*/
  position: relative;
  box-sizing: border-box;
  min-height: 0;
  -webkit-box-flex: 1;
  flex: 1 1 auto;
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
  contain: layout size;
}
.listItem-wrapper {
  box-sizing: border-box;
  position: relative;
  width: 48px;
  height: 48px;
  cursor: pointer;
}
.home-box {
  position: absolute;
  top: 0;
  left: 0;
}
ol,
ul {
  list-style: none;
}
</style>