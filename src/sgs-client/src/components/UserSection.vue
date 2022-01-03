<template>
  <div>
    <section class="my-section">
      <div class="my-section-container">
        <div
          class="my-avatar-wrapper"
          aria-controls="popout"
          aria-expaned="true"
          aria-lable="상태설정"
          role="button"
        >
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
        <div
          class="nametag"
          aria-label="사용자명을 복사하려면 클릭하세요"
          role="button"
          tabindex="0"
        >
          <div class="myname-container">
            <div class="myname">밍디</div>
          </div>
          <div class="mycode">#7959</div>
        </div>
        <div class="mydevice-controller">
          <button
            class="device-controll-button"
            aria-label="마이크"
            role="switch"
            type="button"
          >
            <svg class="mute"></svg>
          </button>
        </div>
        <div class="mydevice-controller">
          <button
            class="device-controll-button"
            aria-label="헤드셋"
            role="switch"
            type="button"
          >
            <svg class="deafen"></svg>
          </button>
        </div>
        <div class="mydevice-controller">
          <button
            class="device-controll-button"
            aria-label="사용자 설정"
            role="switch"
            type="button"
            @click="openSettings"
          >
            <svg class="settings"></svg>
          </button>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
export default {
  methods: {
    openSettings() {
      this.$router.push("/settings");
    },
  },
};
</script>

<style>
.my-section {
  -webkit-box-flex: 0;
  /* -ms-flex: 0 0 auto; */
  flex: 0 0 auto;
  background-color: #292b2f;
  z-index: 1;
}
.my-section-container {
  height: 52px;
  font-size: 14px;
  font-weight: 500;
  /* display: -webkit-box;
    display: -ms-flexbox; */
  display: flex;
  -webkit-box-align: center;
  /* -ms-flex-align: center; */
  align-items: center;
  padding: 0 8px;
  margin-bottom: 1px;
  flex-shrink: 0;
}
.my-avatar-wrapper {
  margin-right: 8px;
}
.nametag {
  cursor: pointer;
  /* -webkit-user-select: text;
    -moz-user-select: text;
    -ms-user-select: text; */
  user-select: text;
  -webkit-box-flex: 1;
  /* -ms-flex-positive: 1; */
  flex-grow: 1;
  margin-right: 4px;
  min-width: 0;
}
.myname-container {
  /* display: -webkit-box;
    display: -ms-flexbox; */
  display: flex;
  -webkit-box-align: center;
  /* -ms-flex-align: center; */
  align-items: center;
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
  font-size: 14px;
  line-height: 18px;
}
.myname {
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
  color: #fff;
  line-height: 18px;
  font-weight: 600;
  font-size: 14px;
  line-height: 18px;
}
.mycode {
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
  color: #b9bbbe;
  line-height: 13px;
  font-size: 12px;
  line-height: 16px;
}
.mydevice-controller {
  flex: 0 1 auto;
  -webkit-box-orient: horizontal;
  -webkit-box-direction: normal;
  /* -ms-flex-direction: row; */
  flex-direction: row;
  /* -ms-flex-wrap: nowrap; */
  flex-wrap: nowrap;
  -webkit-box-pack: start;
  /*  -ms-flex-pack: start; */
  justify-content: flex-start;
  -webkit-box-align: stretch;
  /* -ms-flex-align: stretch; */
  align-items: stretch;
  /*   display: -webkit-box;
  display: -ms-flexbox; */
  display: flex;
}
.device-controll-button {
  line-height: 0;
  width: 32px;
  height: 32px;
  /* display: -webkit-box;
  display: -ms-flexbox; */
  display: flex;
  -webkit-box-align: center;
  /* -ms-flex-align: center; */
  align-items: center;
  -webkit-box-pack: center;
  /* -ms-flex-pack: center; */
  justify-content: center;
  border-radius: 4px;
  position: relative;
  color: #b9bbbe;
  font-size: 14px;
  font-weight: 500;
  background: #00000000;
  border: 0;
  padding: 0;
  margin: 0;
}
.mute {
  display: flex;
  background-image: url("../assets/mute.svg");
  width: 12px;
  height: 17px;
}
.deafen {
  display: flex;
  background-image: url("../assets/deafen.svg");
  width: 16px;
  height: 16px;
}
.settings {
  display: flex;
  background-image: url("../assets/settings.svg");
  width: 16px;
  height: 16px;
}
</style>
