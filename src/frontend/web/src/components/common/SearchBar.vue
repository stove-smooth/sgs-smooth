<template>
  <div class="primary-chatting-search-container">
    <div class="primary-chatting-searchbar">
      <div class="drafteditor-root">
        <div class="drafteditor-container">
          <div class="drafteditor-placeholder-inner">검색하기</div>
        </div>
        <div class="drafteditor-editor-container">
          <div
            class="public-drafteditor-content"
            contenteditable="true"
            role="combobox"
            spellcheck="false"
            aria-haspopup="listbox"
          ></div>
        </div>
      </div>
      <div
        class="icon-layout"
        aria-label="검색 지우기"
        tabindex="-1"
        aria-hidden="true"
        role="button"
      >
        <svg class="small-search-icon"></svg>
      </div>
    </div>
  </div>
</template>

<script>
export default {};
</script>

<style>
.primary-chatting-search-container {
  margin: 0 8px;
  position: relative;
  overflow: visible;
  z-index: 100;
  -webkit-app-region: no-drag;
}
.primary-chatting-searchbar {
  transition: width 0.25s ease;
  box-sizing: border-box;
  display: flex;
  -webkit-box-align: stretch;
  align-items: stretch;
  height: 24px;
  width: 144px;
  border-radius: 4px;
  box-shadow: none;
  cursor: text;
  overflow: hidden;
  padding: 0 2px;
  color: #dcddde;
  background-color: #202225;
  width: 100%;
}
.drafteditor-root {
  -webkit-box-flex: 1;
  flex: 1;
  font-size: 14px;
  font-weight: 500;
  line-height: 20px;
  overflow: hidden;
  padding: 2px 0;
  position: relative;
  height: inherit;
  text-align: initial;
}
.drafteditor-container {
  color: #72767d;
  padding-left: 4px;
  box-sizing: content-box;
  padding-bottom: 20px;
  padding-right: 2px;
  position: absolute;
  z-index: 1;
}
.drafteditor-placeholder-inner {
  white-space: pre-wrap;
}
.drafteditor-editor-container {
  border: none;
  overflow: hidden;
  border-radius: 2px;
  height: 20px;
  background-color: hsla(0, 0%, 100%, 0);
  position: relative;
  z-index: 1;
  text-align: initial;
}
.public-drafteditor-content {
  outline: none;
  user-select: text;
  white-space: pre-wrap;
  overflow-wrap: break-word;
  overflow-x: auto;
  overflow-y: hidden;
  box-sizing: content-box;
  padding-bottom: 20px;
  padding-left: 2px;
  padding-right: 2px;
}
.icon-layout {
  width: 24px;
  height: 24px;
  box-sizing: border-box;
  display: flex;
  -webkit-box-pack: center;
  justify-content: center;
  -webkit-box-align: center;
  align-items: center;
  width: 22px;
  height: 22px;
  cursor: text;
}
.small-search-icon {
  width: 16px;
  height: 16px;
  background-image: url("../../assets/small-search-icon.svg");
}
</style>
