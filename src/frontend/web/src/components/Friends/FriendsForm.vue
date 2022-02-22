<template>
  <div>
    <h2 class="number-of-friends-container small-title-text">
      <slot name="title"></slot>
    </h2>
    <div v-for="item in friend" :key="item.id">
      <div class="firends-list-item" role="listitem" tabindex="-1">
        <div class="friends-list-item-contents">
          <div class="friends-state-info">
            <div class="profile-margin profile-wrapper">
              <img class="avatar" :src="item.profileImage" alt="image" />
              <template
                v-if="item.onlineState != null"
                aria-label="status-invisible"
              >
                <div class="status-ring">
                  <template v-if="item.onlineState == 'offline'"
                    ><div class="status-offline"
                  /></template>
                  <template v-else><div class="status-online" /></template>
                </div>
              </template>
            </div>
            <div class="friends-state-text">
              <div class="discord-name-tag">
                <span class="bold-username">{{ item.name }}</span>
                <span class="user-code">#{{ item.code }}</span>
              </div>
              <div class="status-description">
                <div class="status-subtext">
                  <template v-if="item.onlineState == 'offline'">
                    <span>오프라인</span>
                  </template>
                  <template v-else>
                    <span>온라인</span>
                  </template>
                </div>
              </div>
            </div>
          </div>
          <div class="margin-left-8px display-flex">
            <slot
              name="action"
              v-bind:code="item.code"
              v-bind:id="item.id"
              v-bind:username="item.name"
              v-bind:profileImage="item.profileImage"
              v-bind:userId="item.userId"
            ></slot>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    friend: {
      type: Array,
      required: true,
    },
  },
};
</script>

<style>
.number-of-friends-container {
  margin: 16px 20px 8px 30px;
  color: var(--description-primary);
}
.firends-list-item {
  height: 62px;
  opacity: 1;
  display: flex;
  -webkit-box-orient: horizontal;
  -webkit-box-direction: normal;
  flex-direction: row;
  margin-left: 30px;
  margin-right: 20px;
  font-weight: 500;
  font-size: 16px;
  line-height: 20px;
  overflow: hidden;
  box-sizing: border-box;
  cursor: pointer;
  border-top: 1px solid hsla(0, 0%, 100%, 0.06);
}
.friends-list-item-contents {
  display: flex;
  -webkit-box-flex: 1;
  flex-grow: 1;
  -webkit-box-align: center;
  align-items: center;
  -webkit-box-pack: justify;
  justify-content: space-between;
  max-width: 100%;
}
.friends-state-info {
  display: flex;
  overflow: hidden;
}

.profile-margin {
  margin: 0 12px 0 0;
  flex-shrink: 0;
}
.friends-state-text {
  display: flex;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
  flex-direction: column;
  overflow: hidden;
}

.discord-name-tag {
  display: flex;
  overflow: hidden;
  -webkit-box-flex: 1;
  flex-grow: 1;
  -webkit-box-align: end;
  align-items: flex-end;
  -webkit-box-pack: start;
  justify-content: flex-start;
  line-height: 1.1;
}

.status-description {
  color: var(--description-primary);
  font-size: 12px;
}
.status-subtext {
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
  font-size: 14px;
}
</style>
