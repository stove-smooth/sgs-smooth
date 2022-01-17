<template>
  <nav class="server-sidebar-container">
    <div
      class="tutorial-container clickable"
      @click="setOpenServerPopout"
      :data-container="true"
    >
      <header class="server-sidebar-header">
        <h1 class="server-name">밍디의 서버</h1>
        <div
          class="sidebar-header-button"
          aria-label="밍디님의 서버 활동"
          role="button"
        ></div>
        <div class="sidebar-header-expand-button">
          <svg v-if="openServerPopout" class="small-close"></svg>
          <svg v-else class="expand-down-arrow-icon"></svg>
        </div>
      </header>
    </div>
    <div class="tutorial-container" v-show="false">
      <div class="unread-container">
        <div class="unread-bar">
          <span>읽지 않은 메시지</span>
        </div>
      </div>
    </div>
    <div class="thin-scrollbar dm-scroller">
      <div class="side-content">
        <draggable :list="all" @change="log" group="category">
          <div v-for="element in all" :key="element.id">
            <div
              class="channel-default-container"
              data-dnd-name="element.name"
              aria-label="채널 카테고리"
            >
              <!--카테고리는 드래그 가능해야하며 하위 채널까지 이동됨..-->
              <div class="channel-category-wrapper clickable" role="listitem">
                <div
                  class="channel-category-content"
                  tabindex="-1"
                  role="button"
                >
                  <!--카테고리 클릭시 선택한 채널 외 하위 채널을 접었다 펼 수 있음-->
                  <svg class="small-down-arrow"></svg>
                  <h2 class="small-title-text">{{ element.name }}</h2>
                </div>
                <div
                  class="create-children-wrapper"
                  aria-label="카테고리 하위 채널 생성"
                >
                  <button
                    class="create-channel-button"
                    aria-label="채널 만들기"
                    @click="createChannel(element.name, element.id)"
                  >
                    <svg class="plus-channel-in-this-category"></svg>
                  </button>
                </div>
              </div>
            </div>
            <draggable :list="element.channels" @change="log" group="channel">
              <div
                class="channel-default-container"
                data-dnd-name="일반"
                aria-label="채널"
                v-for="el in element.channels"
                :key="el.id"
              >
                <div class="channel-content-wrapper" role="listitem">
                  <div
                    class="channel-content"
                    @mouseover="hover(el.id)"
                    @mouseleave="unhover"
                  >
                    <div class="channel-main-content">
                      <div
                        v-if="el.type === 'chat'"
                        class="channel-classification-wrapper"
                        aria-label="텍스트"
                      >
                        <svg class="hashtag-icon"></svg>
                      </div>
                      <div
                        v-else
                        class="channel-classification-wrapper"
                        aria-label="음성"
                      >
                        <svg class="voice-channel"></svg>
                      </div>
                      <div class="channel-name-wrapper">
                        <div class="primary-text-content">{{ el.name }}</div>
                      </div>
                    </div>
                    <div
                      class="create-children-wrapper"
                      v-show="hovered === el.id"
                    >
                      <div
                        class="create-children-button"
                        aria-label="초대 코드 만들기"
                        tabindex="0"
                        role="button"
                      >
                        <svg class="invite-people-to-server"></svg>
                      </div>
                      <div
                        class="create-children-button"
                        aria-label="채널 편집"
                        tabindex="0"
                        role="button"
                      >
                        <svg class="small-settings"></svg>
                      </div>
                    </div>
                  </div>
                </div>
                <!----음성 참여자 목록-->
                <div class="voice-participants-list" v-show="false">
                  <div class="draggable">
                    <div class="voice-user-wrapper clickable">
                      <div class="voice-user-content">
                        <div class="small-avatar-wrapper" />
                        <div class="voice-participants-username-wrapper">
                          밍디
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </draggable>
          </div>
        </draggable>
      </div>
    </div>
  </nav>
</template>

<script>
import draggable from "vuedraggable";
import { mapState, mapMutations } from "vuex";
export default {
  components: {
    draggable,
  },
  data() {
    return {
      hovered: "",
      all: [
        {
          id: 1,
          name: "채팅채널",
          channels: [
            {
              id: 3,
              name: "밍디의 채팅채널",
              type: "chat",
            },
            {
              id: 4,
              name: "두리의 채팅채널",
              type: "chat",
            },
            {
              id: 5,
              name: "병찬의 채팅채널",
              type: "chat",
            },
            {
              id: 6,
              name: "희동의 채팅채널",
              type: "chat",
            },
          ],
        },
        {
          id: 2,
          name: "음성채널",
          channels: [
            {
              id: 7,
              name: "노래방",
              type: "voice",
            },
            {
              id: 8,
              name: "라운지",
              type: "voice",
            },
            {
              id: 9,
              name: "광장",
              type: "voice",
            },
          ],
        },
      ],
    };
  },
  computed: {
    ...mapState("server", ["openServerPopout"]),
  },
  methods: {
    ...mapMutations("server", [
      "setCreateChannel",
      "setOpenServerPopout",
      "setCategoryInfo",
    ]),
    add: function () {
      this.list.push({ name: "Juan" });
    },
    clone: function (el) {
      return {
        name: el.name + " cloned",
      };
    },
    log: function (evt) {
      window.console.log(evt);
    },
    hover(index) {
      this.hovered = index;
    },
    unhover() {
      this.hovered = "";
    },
    createChannel(categoryName, categoryId) {
      console.log(categoryName, categoryId);
      const categoryInfo = {
        categoryNmae: categoryName,
        categoryId: categoryId,
      };
      this.setCategoryInfo(categoryInfo);
      this.setCreateChannel(true);
    },
    onClick(e) {
      if (this.openServerPopout) {
        var temp = e.target.parentNode.childNodes[0]._prevClass;
        if (
          temp !== "server-name" &&
          temp !== "server-sidebar-header" &&
          temp !== "expand-down-arrow-icon"
        ) {
          this.setOpenServerPopout();
        }
      }
    },
  },
  mounted() {
    window.addEventListener("click", this.onClick);
  },
};
</script>

<style>
.server-sidebar-container {
  display: flex;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  /* -ms-flex-direction: column; */
  flex-direction: column;
  -webkit-box-align: stretch;
  /* -ms-flex-align: stretch; */
  align-items: stretch;
  -webkit-box-pack: start;
  /* -ms-flex-pack: start; */
  justify-content: flex-start;
  -webkit-box-flex: 1;
  /*  -ms-flex: 1 1 auto; */
  flex: 1 1 auto;
  min-height: 0;
  position: relative;
  background-color: #2f3136;
}
.server-sidebar-header {
  position: relative;
  /* font-family: var(--font-display); */
  font-weight: 500;
  padding: 0 16px;
  height: 48px;
  /* -webkit-box-sizing: border-box; */
  box-sizing: border-box;
  /* display: -webkit-box;
    display: -ms-flexbox; */
  display: flex;
  -webkit-box-align: center;
  /* -ms-flex-align: center; */
  align-items: center;
  z-index: 3;
  /* -webkit-transition: background-color .1s linear; */
  transition: #202225 0.1s linear;
  color: var(--white-color);
  /* -webkit-box-shadow: var(--elevation-low); */
  box-shadow: 0 1px 0 rgba(4, 4, 5, 0.2), 0 1.5px 0 rgba(6, 6, 7, 0.05),
    0 2px 0 rgba(4, 4, 5, 0.05);
}
.server-name {
  font-size: 15px;
  line-height: 20px;
  font-weight: 600;
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
  -webkit-box-flex: 1;
  /* -ms-flex: 1; */
  flex: 1;
}
.sidebar-header-button {
  position: absolute;
  left: 0;
  right: 0;
  top: 0;
  bottom: 0;
  pointer-events: none;
}
.sidebar-header-expand-button {
  position: relative;
  z-index: 4;
}

.expand-down-arrow-icon {
  display: flex;
  background-image: url("../assets/down-arrow.svg");
  width: 12px;
  height: 6px;
}
.unread-container {
  top: 0;
  left: 0;
  right: 0;
  position: absolute;
  z-index: 2;
  overflow: hidden;
  padding: 8px;
  height: 24px;
  pointer-events: none;
}
.unread-bar {
  transform: translateY(0%);
  background-color: #ff0000;
  opacity: 0.7;
  /* display: -webkit-box;
  display: -ms-flexbox; */
  display: flex;
  -webkit-box-align: center;
  /* -ms-flex-align: center; */
  align-items: center;
  -webkit-box-pack: center;
  /* -ms-flex-pack: center; */
  justify-content: center;
  position: relative;
  font-size: 12px;
  line-height: 16px;
  /* font-family: var(--font-display); */
  font-weight: 600;
  color: var(--white-color);
  height: 24px;
  cursor: pointer;
  text-transform: uppercase;
  border-radius: 12px;
  pointer-events: auto;
  /* -webkit-box-shadow: 0 2px 6px rgb(0 0 0 / 24%); */
  box-shadow: 0 2px 6px rgb(0 0 0 / 24%);
  -webkit-app-region: no-drag;
}
.channel-default-container {
  position: relative;
  padding-top: 16px;
}
.channel-category-wrapper {
  position: relative;
  /* -webkit-box-sizing: border-box; */
  box-sizing: border-box;
  height: 0px;
  padding-right: 8px;
  padding-left: 16px;
  /* display: -webkit-box;
  display: -ms-flexbox; */
  display: flex;
  -webkit-box-align: center;
  /* -ms-flex-align: center; */
  align-items: center;
  -webkit-box-pack: justify;
  /* -ms-flex-pack: justify; */
  justify-content: space-between;
  /* cursor: default; */
  color: #8e9297;
}
.channel-category-content {
  /* -webkit-box-flex: 1; */
  /* -ms-flex: 1 1 auto; */
  /* flex: 1 1 auto; */
  overflow: hidden;
  display: flex;
  flex-direction: row;
  align-items: center;
}
.small-down-arrow {
  display: flex;
  width: 8px;
  height: 4px;
  margin-right: 5px;
  background-image: url("../assets/small-down-arrow.svg");
}
.small-close {
  width: 12px;
  height: 12px;
  background-image: url("../assets/small-close.svg");
}
.create-children-wrapper {
  display: flex;
  -webkit-box-align: center;
  align-items: center;
  -webkit-box-pack: center;
  justify-content: center;
  -webkit-box-flex: 0;
  flex: 0 0 auto;
}
.create-channel-button {
  display: block;
  /* font-family: var(--font-korean); */
  width: 18px;
  height: 18px;
  background: transparent;
  color: currentColor;
  border: 0;
  padding: 0;
  margin: 0;
  position: relative;
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
.channel-content-wrapper {
  padding: 1px 0;
  overflow: visible;
  position: relative;
}
.channel-content {
  position: relative;
  /* -webkit-box-sizing: border-box; */
  box-sizing: border-box;
  padding: 0 8px;
  margin-left: 8px;
  border-radius: 4px;
  /* display: -webkit-box;
  display: -ms-flexbox; */
  display: flex;
  -webkit-box-orient: horizontal;
  -webkit-box-direction: normal;
  /* -ms-flex-direction: row; */
  flex-direction: row;
  -webkit-box-align: center;
  /* -ms-flex-align: center; */
  align-items: center;
}
.channel-content:hover {
  background-color: rgba(79, 84, 92, 0.32);
}
.channel-content:active {
  background-color: rgba(79, 84, 92, 0.32);
}
.channel-content:visited {
  background-color: rgba(79, 84, 92, 0.32);
}
.channel-main-content {
  -webkit-box-flex: 1;
  /* -ms-flex: 1 1 auto; */
  flex: 1 1 auto;
  /*  -webkit-box-sizing: border-box; */
  box-sizing: border-box;
  /* display: -webkit-box;
  display: -ms-flexbox; */
  display: flex;
  -webkit-box-orient: horizontal;
  -webkit-box-direction: normal;
  /* -ms-flex-direction: row; */
  flex-direction: row;
  -webkit-box-align: center;
  /* -ms-flex-align: center; */
  align-items: center;
  min-width: 0;
  padding: 6px 0;
  cursor: pointer;
}
.channel-classification-wrapper {
  position: relative;
  margin-right: 6px;
}
.hashtag-icon {
  display: flex;
  width: 18px;
  height: 18px;
  background-image: url("../assets/hashtag.svg");
}
.channel-name-wrapper {
  font-size: 16px;
  line-height: 20px;
  font-weight: 500;
  -webkit-box-flex: 1;
  /* -ms-flex: 1 1 auto; */
  flex: 1 1 auto;
  white-space: normal;
  text-overflow: ellipsis;
  overflow: hidden;
  position: relative;
  color: var(--white-color);
}

.create-children-button {
  padding: 6px 2px;
  position: relative;
  cursor: pointer;
  line-height: 0;
}
.invite-people-to-server {
  width: 16px;
  height: 16px;
  background-image: url("../assets/invite-people-to-server.svg");
}
.small-settings {
  width: 12px;
  height: 12px;
  background-image: url("../assets/small-settings.svg");
}
.voice-channel {
  display: block;
  width: 16px;
  height: 16px;
  background-image: url("../assets/voice-channel.svg");
}
.voice-participants-list {
  padding-left: 36px;
  padding-bottom: 8px;
  -webkit-box-direction: normal;
  -webkit-box-orient: vertical;
  /* -ms-flex-direction: column; */
  flex-direction: column;
  /*  -ms-flex-wrap: nowrap; */
  flex-wrap: nowrap;
  -webkit-box-align: stretch;
  /* -ms-flex-align: stretch; */
  align-items: stretch;
  /* display: -webkit-box;
  display: -ms-flexbox; */
  display: flex;
  -webkit-box-pack: start;
  /* -ms-flex-pack: start; */
  justify-content: flex-start;
}
.draggable {
  position: relative;
  height: 32px;
}
.voice-user-wrapper {
  position: relative;
  height: 32px;
}
.voice-user-content {
  /* display: -webkit-box;
  display: -ms-flexbox; */
  display: flex;
  border-radius: 4px;
  -webkit-box-pack: start;
  /* -ms-flex-pack: start; */
  justify-content: flex-start;
  -webkit-box-align: center;
  /* -ms-flex-align: center; */
  align-items: center;
  margin-top: 1px;
  margin-bottom: 1px;
}
.small-avatar-wrapper {
  background-image: url("https://cdn.discordapp.com/avatars/405352159685902340/3826d665833a6f43e9e438469edaa75b.webp?size=24");
  margin-right: 8px;
  margin-left: 8px;
  width: 24px;
  height: 24px;
  -webkit-box-flex: 0;
  /* -ms-flex: 0 0 auto; */
  flex: 0 0 auto;
  border-radius: 50%;
  background-size: cover;
  background-repeat: no-repeat;
  background-position: 50% 50%;
  margin-top: 3px;
  margin-bottom: 3px;
}
.voice-participants-username-wrapper {
  color: #8e9297;
  font-size: 14px;
  line-height: 18px;
  font-weight: 500;
  -webkit-box-flex: 1;
  /* -ms-flex: 1 1 auto; */
  flex: 1 1 auto;
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
}
.plus-channel-in-this-category {
  width: 12px;
  height: 12px;
  margin-left: 0;
  margin-right: 2px;
  background-image: url("../assets/private-channel-plus.svg");
}
</style>
