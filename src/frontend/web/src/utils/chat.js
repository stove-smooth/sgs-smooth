import store from "@/store/index";

function clickPlusAction(event,messageInfo){
  const x = event.clientX;
  const y = event.clientY;
  store.commit("utils/setClientX",x);
  store.commit("utils/setClientY",y);
  store.commit("community/setMessagePlusMenu",messageInfo);
}

function emojiClose(e){
  var condition1 = e.target.parentNode.childNodes[0]._prevClass;
  var condition2 = e.target.parentNode.className;
  const isEmojiClass = ["container-search","container-emoji","svg","emoji-button","emoji-picker-popout","emoji-picker-popout emoji-picker"].includes(condition2);
  const isReplyEmojiClass = ["reply-emoji-picker-popout","reply-emoji-picker-popout emoji-picker"].includes(condition2);
  if (!(
    isEmojiClass||
    isReplyEmojiClass||
    condition1 === "category")
  ) {
    return true;
  }else{
    return false;
  }
}
export {
  clickPlusAction,
  emojiClose
};