<template>
  <div class="server-activity-container1">
    <div class="server-chatting-container">
      <div class="message-container">
        <div class="thin-scrollbar server-chat-scroller">
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
                      <span class="chat-user-name">user0</span>
                      <span class="chat-time-stamp">어제 오후 11:56</span>
                    </h2>
                    <div class="message-content">안녕~^^</div>
                  </div>
                </div>
              </li>
            </ol>
          </div>
        </div>
      </div>
      <form class="channel-message-input-form">
        <div class="channel-message-area">
          <div class="channel-message-scrollbar-container">
            <div v-show="false">
              <!--ul에 scrollbar추가필요.-->
              <ul
                class="channel-attachment-area"
                role="list"
                data-list-id="attachments"
              >
                <li
                  class="upload-attachments"
                  role="listitem"
                  data-list-item-id="attachments-upload"
                  tabindex="-1"
                >
                  <div class="message-upload-container">
                    <div class="message-upload-image-container"></div>
                    <div class="message-upload-filename-container"></div>
                    <div class="message-upload-actionbar-container"></div>
                  </div>
                </li>
              </ul>
            </div>
            <div class="message-attachment-divider"></div>
            <div class="channel-message-form-inner-button">
              <div class="message-upload-input">
                <input
                  class="file-input"
                  type="file"
                  tabindex="-1"
                  multiple
                  aria-hidden="true"
                />
              </div>
              <div class="message-attach-button-wrapper">
                <button
                  class="message-attach-button"
                  aria-label="파일을 업로드하거나 초대를 보내세요"
                >
                  <div class="attach-button-inner">
                    <svg class="attach-button"></svg>
                  </div>
                </button>
              </div>
              <div class="channel-message-input-area">
                <div class="channel-message-input-placeholder">
                  #잡담에 메시지 보내기
                </div>
                <div
                  class="channel-message-input-wrapper"
                  aria-haspopup="listbox"
                  aria-label="#잡담에서 메시지보내기"
                  aria-multiline="true"
                  contenteditable="true"
                  role="textbox"
                ></div>
              </div>
            </div>
          </div>
        </div>
      </form>
    </div>
    <div class="server-member-container">
      <aside class="server-member-list-wrapper">
        <div class="thin-scrollbar dm-scroller server-members" tabinex="0">
          <div role="list" aria-label="멤버" class="server-member-list">
            <h2 class="members-group-container" aria-label="온라인">
              온라인 - 5
            </h2>
            <div v-for="(item, index) in 5" :key="index">
              <div class="primary-member-container clickable" role="listitem">
                <div class="primary-member-layout">
                  <div class="avatar-container">
                    <div class="profile-wrapper" aria-label="칭구1">
                      <div class="avatar-wrapper">
                        <img
                          class="avatar"
                          src="https://cdn.discordapp.com/avatars/846330810000605208/e581f53f2ba1f0d06bbcd7b512834a47.webp?size=32"
                          alt=" "
                        />
                        <template aria-label="status-invisible">
                          <div class="status-ring">
                            <div class="status-online"></div>
                          </div>
                        </template>
                      </div>
                    </div>
                  </div>
                  <div class="friends-contents">
                    <div class="friends-name-decorator">
                      <div class="friends-name">user{{ index }}</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div role="list" aria-label="멤버" class="server-member-list">
            <h2 class="members-group-container" aria-label="온라인">
              오프라인 - 3
            </h2>
            <div v-for="(item, index) in 3" :key="index">
              <div class="primary-member-container clickable" role="listitem">
                <div class="primary-member-layout">
                  <div class="avatar-container">
                    <div class="profile-wrapper" aria-label="칭구1">
                      <div class="avatar-wrapper">
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
                  <div class="friends-contents">
                    <div class="friends-name-decorator">
                      <div class="friends-name">user{{ index + 5 }}</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </aside>
    </div>
  </div>
</template>

<script>
export default {};
</script>

<style>
.server-activity-container1 {
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
.server-chat-scroller {
  overflow: hidden scroll;
  padding-right: 0px;
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
  color: var(--white-color);
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
.channel-message-input-form {
  position: relative;
  /* -ms-flex-negative: 0; */
  flex-shrink: 0;
  padding-left: 16px;
  padding-right: 16px;
  margin-top: -8px;
}
.channel-message-area {
  margin-bottom: 24px;
  background-color: #36393f;
  position: relative;
  width: 100%;
  text-indent: 0;
  border-radius: 8px;
}
.channel-message-scrollbar-container {
  overflow-x: hidden;
  overflow-y: scroll;
  background-color: #40444b;
  max-height: 50vh;
  border-radius: 8px;
}
.channel-message-form-inner-button {
  display: flex;
  position: relative;
  padding-left: 16px;
}
.message-attachment-divider {
  z-index: 1;
  height: 0;
  border-top: thin solid hsla(0, 0%, 100%, 0.06);
  /* display: -webkit-box;
  display: -ms-flexbox; */
  display: flex;
  -webkit-box-align: center;
  /*  -ms-flex-align: center; */
  align-items: center;
  -webkit-box-pack: center;
  /* -ms-flex-pack: center; */
  justify-content: center;
  position: relative;
  -webkit-box-flex: 0;
  /* -ms-flex: 0 0 auto; */
  flex: 0 0 auto;
  pointer-events: none;
  /* -webkit-box-sizing: border-box; */
  box-sizing: border-box;
  --divider-color: hsl(359, calc(var(1, 1) * 82.6%), 59.4%);
}
.channel-attachment-area {
  gap: 24px;
  margin: 0 0 2px 6px;
  padding: 20px 10px 10px;
  overflow-x: auto;
  display: flex;
}
.upload-attachments {
  display: inline-flex;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  /* -ms-flex-direction: column; */
  flex-direction: column;
  background-color: #2f3136;
  border-radius: 4px;
  margin: 0;
  padding: 8px;
  position: relative;
  min-width: 200px;
  max-width: 200px;
  min-height: 200px;
  max-height: 200px;
}
.message-upload-container {
  display: flex;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  /* -ms-flex-direction: column; */
  flex-direction: column;
  height: 100%;
}
.message-upload-image-container {
  margin-top: auto;
  position: relative;
  min-height: 0;
}
.message-upload-filename-container {
  margin-top: auto;
}
.message-upload-actionbar-container {
  position: absolute;
  top: 0;
  right: 0;
}
.message-upload-input {
  position: relative;
  width: 0;
  height: 0;
  pointer-events: none;
}
.message-attach-button-wrapper {
  position: sticky;
  -webkit-box-flex: 0;
  flex: 0 0 auto;
  align-self: stretch;
}
.message-attach-button {
  height: 44px;
  padding: 10px 16px;
  position: sticky;
  top: 0;
  cursor: pointer;
  margin-left: -16px;
  width: auto;
  background: transparent;
  border: 0;
  margin: 0;
  display: flex;
  -webkit-box-pack: center;
  justify-content: center;
  -webkit-box-align: center;
  align-items: center;
  box-sizing: border-box;
  border-radius: 3px;
  font-size: 14px;
  font-weight: 500;
  line-height: 16px;
}
.attach-button-inner {
  height: 24px;
}
.attach-button {
  width: 24px;
  height: 24px;
  background-image: url("../assets/attach-button.svg");
}
.channel-message-input-area {
  padding: 0px;
  background-color: transparent;
  resize: none;
  border: none;
  appearance: none;
  box-sizing: border-box;
  font-weight: 400;
  font-size: 1rem;
  line-height: 1.375rem;
  width: 100%;
  min-height: 44px;
  color: #dcddde;
  position: relative;
}
.channel-message-input-placeholder {
  padding-bottom: 11px;
  padding-top: 11px;
  padding-right: 10px;
  left: 0;
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
  position: absolute;
  right: 0;
  user-select: none;
  color: #72767d;
}
.channel-message-input-wrapper {
  outline: none;
  overflow-wrap: break-word;
  -webkit-user-modify: read-write-plaintext-only;
  padding-bottom: 11px;
  padding-top: 11px;
  padding-right: 10px;
  caret-color: #dcddde;
  position: absolute;
  left: 0;
  right: 10px;
  text-align: left;
  word-break: break-word;
  white-space: break-spaces !important;
  font-size: 1rem;
  line-height: 1.375rem;
  user-select: text;
  color: #dcddde;
  font-weight: 400;
}
.server-member-list-wrapper {
  -webkit-box-pack: center;
  justify-content: center;
  min-width: 240px;
  position: relative;
  max-height: 100%;
  display: flex;
}
.server-members {
  width: 240px;
  padding: 0 0 20px;
  -webkit-box-flex: 0;
  flex: 0 0 auto;
  height: auto;
}
.server-member-list {
  background-color: #2f3136;
  position: relative;
  height: auto;
}
.members-group-container {
  padding: 24px 8px 0 16px;
  height: 40px;
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
  -ms-flex: 1 1 auto;
  flex: 1 1 auto;
  color: #8e9297;
}
</style>
