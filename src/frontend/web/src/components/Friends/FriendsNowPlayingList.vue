<template>
  <div class="friends-now-playing-list">
    <div
      class="frineds-now-playing-container thin-scrollbar now-playing-scroller"
    >
      <h3 class="header-title">현재 활동 중</h3>
      <div v-for="(item, index) in 1" :key="index">
        <div class="now-playing-card" tabindex="0" role="button">
          <div>
            <header class="now-playing-card-header">
              <div class="profile-margin profile-wrapper">
                <img
                  class="avatar"
                  src="../../assets/default_stove.png"
                  alt=" "
                />
                <template aria-label="status-invisible">
                  <div class="status-ring">
                    <div class="status-offline"></div>
                  </div>
                </template>
              </div>
              <div>
                <div class="large-white-description primary-text-content">
                  밍디
                </div>
                <div class="primary-text-content status-description">
                  음성 채널 참여 중
                </div>
              </div>
            </header>
            <div class="now-playing-card-body">
              <section class="now-playing-server-container">
                <div class="now-playing-server">
                  <div tabindex="-1" role="button">
                    <div class="profile-wrapper justify-content-center">
                      <img
                        class="profile-wrapper"
                        alt="image"
                        src="https://cdn.discordapp.com/icons/917657762341740544/a82e694e7074d90e39503ee0a9044f46.webp?size=32"
                      />
                      <div class="voice-section-wrapper">
                        <svg class="small-voice-channel"></svg>
                      </div>
                    </div>
                  </div>
                  <div tabindex="0" role="button">
                    <div class="clickable" aria-label="voice-section-details">
                      <div class="large-white-description primary-text-content">
                        스무th
                      </div>
                      <div class="subtext" v-bind:style="{ color: '#dcddde' }">
                        공부방1
                      </div>
                    </div>
                  </div>
                  <!-- <div class="voice-section-members-wrapper">
                    <div class="voice-section-members">
                      <div class="known-voice-section-member">
                        <img
                          class="small-profile-wrapper"
                          alt="image"
                          src="https://cdn.discordapp.com/avatars/846330810000605208/e581f53f2ba1f0d06bbcd7b512834a47.webp?size=32"
                        />
                      </div>
                    </div>
                    <div class="voice-section-members">
                      <div class="known-voice-section-member">
                        <img
                          class="small-profile-wrapper"
                          alt="image"
                          src="https://cdn.discordapp.com/avatars/846330810000605208/e581f53f2ba1f0d06bbcd7b512834a47.webp?size=32"
                        />
                      </div>
                    </div>
                  </div> -->
                </div>
              </section>
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
.friends-now-playing-list {
  -webkit-box-flex: 0;
  flex: 0 1 30%;
  min-width: 360px;
  max-width: 420px;
  background: #2f3136;
}
.frineds-now-playing-container {
  background-color: #36393f;
  height: 100%;
  border-left: 1px solid hsla(0, 0%, 100%, 0.06);
}
.now-playing-card {
  margin-top: 0;
  border-radius: 8px;
  background-color: #2f3136;
  border: 1px solid hsla(0, 0%, 100%, 0.06);
  cursor: pointer;
  padding: 16px;
}
.now-playing-card-header {
  grid-template-columns: 32px minmax(20px, auto) 24px;
  position: relative;
  display: grid;
  -webkit-box-align: center;
  align-items: center;
  height: 36px;
  grid-gap: 12px;
}
.now-playing-card-body {
  background-color: #2f3136;
  margin-top: 12px;
  border-radius: 8px;
}
.now-playing-server-container {
  border-radius: 8px;
  position: relative;
  padding: 12px;
  background-color: #36393f;
}
.now-playing-server {
  -webkit-box-align: center;
  align-items: center;
  display: grid;
  grid-template-columns: 32px minmax(20px, auto) max-content;
  grid-gap: 12px;
}
.voice-section-wrapper {
  background-color: #18191c;
  width: 16px;
  height: 16px;
  border-radius: 50%;
  display: flex;
  -webkit-box-pack: center;
  justify-content: center;
  -webkit-box-align: center;
  align-items: center;
  position: absolute;
  bottom: -2px;
  right: -2px;
}
.small-voice-channel {
  width: 10px;
  height: 10px;
  background-image: url("../../assets/small-voice-channel.svg");
}
.voice-section-members-wrapper {
  display: flex;
  height: 24px;
  -webkit-box-pack: end;
  justify-content: flex-end;
  -webkit-box-align: center;
  align-items: center;
}
.voice-section-members-wrapper {
  display: flex;
  height: 24px;
  -webkit-box-pack: end;
  justify-content: flex-end;
  -webkit-box-align: center;
  align-items: center;
}
.voice-section-members {
  display: flex;
  height: 24px;
}
.known-voice-section-member {
  width: 24px;
  height: 24px;
  display: inline-block;
}
.small-profile-wrapper {
  position: absolute;
  width: 24px;
  height: 24px;
  position: relative;
  border-radius: 50%;
}
.now-playing-scroller {
  overflow: hidden scroll;
  padding: 16px;
}
</style>
