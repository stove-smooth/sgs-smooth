function emojiClose(e){
  var condition1 = e.target.parentNode.childNodes[0]._prevClass;
  var condition2 = e.target.parentNode.className;
  const isEmojiClass = ["container-search","container-emoji","svg","emoji-button","emoji-picker-popout","emoji-picker-popout emoji-picker"].includes(condition2);
  const isReplyEmojiClass = ["reply-emoji-picker-popout","reply-emoji-picker-popout emoji-picker"].includes(condition2);
  return (!(
    isEmojiClass||
    isReplyEmojiClass||
    condition1 === "category")
  );
}

function transImg(text){
  var urlRegex = /(https?:\/\/[^\s]+)/g;
    return text.replace(urlRegex, function (url) {
    return `<img alt="이미지" src="${url}"/>`;
  });
}
//한국 시간에 맞게 시간 변환
function convertFromStringToDate(responseDate) {
  var time = {};
  let dateComponents = responseDate.split("T");
  dateComponents[0].split("-");
  let timePieces = dateComponents[1].split(":");
  let transDate;
  if (parseInt(timePieces[0]) + 9 < 24) {
    time.hour = parseInt(timePieces[0]) + 9;
    let tempDate = new Date(dateComponents[0]);
    transDate = tempDate.toLocaleDateString();
  } else {
    time.hour = parseInt(timePieces[0]) + 9 - 24;
    var newDate = new Date(dateComponents[0]);
    newDate.setDate(newDate.getDate() + 1);
    transDate = newDate.toLocaleDateString();
  }
  time.minutes = parseInt(timePieces[1]);
  return [transDate, time.hour + ":" + time.minutes];
}
//같은 시간대의 메세지인지 판별
function isSameTime(prev, current) {
  //먼저 날이 같을때.
  return (prev.date == current.date &&prev.time == current.time)
}

//실시간 연속된 메세지 처리
function realMessageInarow(receivedForm,receiveList){
  const translatedTime = convertFromStringToDate(receivedForm.time);
  receivedForm.date = translatedTime[0];
  receivedForm.time = translatedTime[1];
  //연속된 메시지 처리(같은 유저의 메시지인지, 동일시간의 메시지인지 구분)
  let isOther = true;
  if (receiveList.length > 0) {
    const timeResult = isSameTime(
      receiveList[receiveList.length - 1],
      receivedForm
    );
    if (
      timeResult &&
      receiveList[receiveList.length - 1].userId ==
        receivedForm.userId
    ) {
      isOther = false;
    }
  }
  receivedForm.isOther = isOther;
}

function readMessageInarow(receivedAllMessage,i){
  const translatedTime = convertFromStringToDate(
    receivedAllMessage[i].time
  );
  receivedAllMessage[i].date = translatedTime[0];
  receivedAllMessage[i].time = translatedTime[1];
  //연속된 메시지 처리(같은 유저의 메시지인지, 동일시간의 메시지인지 구분)
  let isOther = true;
  if (i != 0) {
    const timeResult = isSameTime(
      receivedAllMessage[i - 1],
      receivedAllMessage[i]
    );
    if (
      timeResult &&
      receivedAllMessage[i - 1].userId == receivedAllMessage[i].userId
    ) {
      isOther = false;
    }
  }
  receivedAllMessage[i].isOther = isOther;
}
export {
  emojiClose,
  transImg,
  convertFromStringToDate,
  isSameTime,
  realMessageInarow,
  readMessageInarow,
};