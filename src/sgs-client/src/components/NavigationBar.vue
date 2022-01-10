<template>
  <nav class="nav-wrapper" aria-label="서버 사이드바.">
    <ul role="tree" tabindex="0" data-list-id="guildnav" class="tree">
      <div class="thin-scrollbar nav-scroller">
        <div class="tutorial-container">
          <div
            class="listItem"
            @mouseover="hover('me')"
            @mouseleave="unhover"
            @click="enterMe('me')"
          >
            <div
              class="selected-wrapper"
              v-show="hovered === 'me' || selected === 'me'"
            >
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
          <div v-for="(item, index) in serverlist" :key="index">
            <div
              class="listItem"
              @mouseover="hover(index)"
              @mouseleave="unhover"
              @click="enterServer(index)"
            >
              <div
                class="selected-wrapper"
                v-show="hovered === index || selected === index"
              >
                <span class="selected-item"></span>
              </div>
              <div draggable="true">
                <div class="listItem-wrapper">
                  <div class="server-wrapper" v-if="item.thumbnail">
                    <img
                      :src="item.thumbnail"
                      alt="image"
                      class="server-nav-image"
                    />
                  </div>
                  <div class="server-wrapper" v-else>
                    <div class="server">{{ item.name }}</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="tutorial-container">
          <div class="listItem" @click="openCreate">
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
</template>

<script>
const storage = {
  fetch() {
    const serveritems = localStorage.getItem(3) || "[]";
    const result = JSON.parse(serveritems);
    return result;
  },
};
export default {
  data() {
    return {
      hovered: "",
      selected: "me",
      images: "",
      serverlist: [],
    };
  },
  methods: {
    openCreate() {
      this.$emit("create-server");
    },
    fetchTodoItems() {
      this.serverlist = storage.fetch();
    },
    hover(index) {
      this.hovered = index;
    },
    unhover() {
      this.hovered = "";
    },
    select(index) {
      this.selected = index;
    },
    unselect() {
      this.selected = "";
    },
    enterServer(index) {
      this.$router.push("/channels/" + index).catch((err) => {
        console.log(err);
      });
      this.select(index);
    },
    enterMe(index) {
      this.$router.push("/channels/@me");
      this.select(index);
    },
  },
  created() {
    this.fetchTodoItems();
  },
};
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
.nav-scroller {
  overflow: hidden scroll;
  padding-right: 0px;
  background-color: #202225;
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
  font-weight: 500;
  line-height: 1.2em;
  white-space: nowrap;
  background-color: #36393f;
  color: #dcddde;
  display: flex;
  width: 48px;
  height: 48px;
  -webkit-box-align: center;
  align-items: center;
  -webkit-box-pack: center;
  justify-content: center;
  overflow: hidden;
  border-radius: 50%;
}
.server-wrapper {
  font-size: 12px;
  display: flex;
  width: 48px;
  height: 48px;
  -webkit-box-align: center;
  align-items: center;
  -webkit-box-pack: center;
  justify-content: center;
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
  background-image: url("../assets/channel-plus.svg");
}

.server-nav-image {
  display: flex;
  width: 48px;
  height: 48px;
  border-radius: 50%;
  position: relative;
}
ol,
ul {
  list-style: none;
}
</style>
