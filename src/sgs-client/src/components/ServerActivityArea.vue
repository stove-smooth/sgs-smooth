<template>
  <div class="server-activity-container">
    <div class="server-chatting-container"></div>
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
</style>
