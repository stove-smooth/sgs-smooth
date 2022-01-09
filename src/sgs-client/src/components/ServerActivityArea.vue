<template>
  <div class="server-activity-container">
    <div class="server-chatting-container">
      <div class="message-container">
        <div class="thin-scrollbar dm-scroller">
          <div class="scroller-content">
            <ol class="scroller-inner">
              <li class="chat-message-wrapper">
                <div class="chat-message-wrapper2">
                  <div class="chat-message-content">
                    <img
                      src="https://cdn.discordapp.com/avatars/846330810000605208/e581f53f2ba1f0d06bbcd7b512834a47.webp?size=80"
                      class="chat-avatar clickable"
                      alt="image"
                    />
                    <h2 class="chat-avatar-header">
                      <span class="chat-user-name">두리짱</span>
                      <span class="chat-time-stamp">어제 오후 11:56</span>
                    </h2>
                    <div class="message-content">개철벽 김희동</div>
                  </div>
                </div>
              </li>
            </ol>
          </div>
        </div>
      </div>
    </div>
    <div class="server-member-container"></div>
  </div>
</template>

<script>
export default {};
</script>

<style>
.server-activity-container {
  min-width: 0;
  min-height: 0;
  -webkit-box-flex: 1;
  /*  -ms-flex: 1 1 auto; */
  flex: 1 1 auto;
  /* display: -webkit-box;
  display: -ms-flexbox; */
  display: flex;
  -webkit-box-orient: horizontal;
  -webkit-box-direction: normal;
  /* -ms-flex-direction: row; */
  flex-direction: row;
  /* -webkit-box-pack: stretch; */
  /* -ms-flex-pack: stretch; */
  justify-content: stretch;
  -webkit-box-align: stretch;
  /* -ms-flex-align: stretch; */
  align-items: stretch;
  position: relative;
}
.server-chatting-container {
  position: relative;
  /* display: -webkit-box;
  display: -ms-flexbox; */
  display: flex;
  height: 100%;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  /* -ms-flex-direction: column; */
  flex-direction: column;
  min-width: 0;
  min-height: 0;
  -webkit-box-flex: 1;
  /* -ms-flex: 1 1 auto; */
  flex: 1 1 auto;
}
.server-member-container {
  display: flex;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  /* -ms-flex-direction: column; */
  flex-direction: column;
  background: #2f3136;
  height: 100%;
}
.message-container {
  display: flex;
  position: relative;
  -webkit-box-flex: 1;
  flex: 1 1 auto;
  min-height: 0;
  min-width: 0;
  z-index: 0;
}
.scroller-content {
  overflow-anchor: none;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  flex-direction: column;
  -webkit-box-pack: end;
  justify-content: flex-end;
  -webkit-box-align: stretch;
  align-items: stretch;
  min-height: 100%;
  display: flex;
  position: relative;
}
.scroller-inner {
  min-height: 0;
  list-style: none;
}
.chat-message-wrapper {
  outline: none;
}
.chat-message-wrapper2 {
  margin-top: 1.0625rem;
  min-height: 2.75rem;
  padding-left: 72px;
  padding-top: 0.125rem;
  padding-bottom: 0.125rem;
  padding-right: 48px !important;
  position: relative;
  word-wrap: break-word;
  user-select: text;
  -webkit-box-flex: 0;
  flex: 0 0 auto;
}
.chat-message-content {
  position: static;
  margin-left: 0;
  padding-left: 0;
  text-indent: 0;
}
.chat-avatar {
  pointer-events: auto;
  position: absolute;
  left: 16px;
  margin-top: calc(4px - 0.125rem);
  width: 40px;
  height: 40px;
  border-radius: 50%;
  overflow: hidden;
  cursor: pointer;
  user-select: none;
  -webkit-box-flex: 0;
  flex: 0 0 auto;
  z-index: 1;
}
.chat-avatar-header {
  display: block;
  position: relative;
  line-height: 1.375rem;
  min-height: 1.375rem;
  color: #72767d;
  white-space: break-spaces;
}
.chat-user-name {
  font-size: 1rem;
  font-weight: 500;
  line-height: 1.375rem;
  color: #fff;
  display: inline;
  vertical-align: baseline;
  position: relative;
  overflow: hidden;
  flex-shrink: 0;
}
.chat-time-stamp {
  font-size: 0.75rem;
  line-height: 1.375rem;
  color: #72767d;
  vertical-align: baseline;
  margin-left: 0.25rem;
  display: inline-block;
  height: 1.25rem;
  cursor: default;
  pointer-events: none;
  font-weight: 500;
}
.message-content {
  user-select: text;
  margin-left: -72px;
  padding-left: 72px;
  overflow: hidden;
  position: relative;
  text-indent: 0;
  font-size: 1rem;
  line-height: 1.375rem;
  white-space: break-spaces;
  word-wrap: break-word;
  color: #dcddde;
  font-weight: 400;
}
</style>
