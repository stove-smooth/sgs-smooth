import { createDirectMessage } from "@/api/index.js";
import { router } from "../routes";
//유저코드에 따라 기본 프로필을 설정한다.
function selectProfile(code) {
  if (code == 0) {
    return "discord_blue";
  } else if (code == 1) {
    return "discord_green";
  } else if (code == 2) {
    return "discord_grey";
  } else {
    return "discord_red";
  }
}

function processFile(image) {
  return new Promise((resolve) => {
    const reader = new FileReader();
    reader.readAsDataURL(image);
    reader.onload = () => {
      let tempImage = new Image();
      tempImage.src = reader.result;
      resolve(tempImage);
    };
  });
}
function processFile2(tempImage) {
  let dataURI;
  let thumbnail;
  return new Promise((resolve) => {
    tempImage.onload = function () {
      let canvas = document.createElement("canvas");
      let canvasContext = canvas.getContext("2d");

      canvas.width = 100;
      canvas.height = 100;

      canvasContext.drawImage(this, 0, 0, 100, 100);

      dataURI = canvas.toDataURL("image/jpeg");
      thumbnail = dataURI;
      resolve(thumbnail);
    };
  });
}
//이미지를 썸네일로 변환한다.
async function converToThumbnail(image) {
  const result = await processFile(image);
  const thumbnail = await processFile2(result);
  return thumbnail;
}
//썸네일을 파일로 만든다.
async function dataUrlToFile(dataUrl) {
  const response = await fetch(dataUrl);
  const blob = await response.blob();
  const time = new Date().getTime();
  return new File([blob], time, { type: "image/*" });
}
//채널의 이름을 계산한다.
function computeChannelName(id, communityInfo) {
  let channel = "";
  const categories = communityInfo.categories;
  for (var category in categories) {
    if (categories[category].channels != null) {
      for (let i = 0; i < categories[category].channels.length; i++) {
        if (categories[category].channels[i].id == id) {
          channel = categories[category].channels[i].name;
          return channel;
        }
      }
    }
  }
}
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

async function sendDirectMessage(directMessageList, userId) {
  for (let i = 0; i < directMessageList.length; i++) {
    if (directMessageList[i].group == false) {
      if (directMessageList[i].members.includes(userId)) {
        //location.assign(`/channels/@me/${directMessageList[i].id}`);
        router.push(`/channels/@me/${directMessageList[i].id}`);
        return;
      }
    }
  }
  const dmMembers = {
    members: [userId],
  };
  const result = await createDirectMessage(dmMembers);
  //location.assign(`/channels/@me/${result.data.result.id}`);
  router.push(`/channels/@me/${result.data.result.id}`);
}

export {
  selectProfile,
  converToThumbnail,
  dataUrlToFile,
  computeChannelName,
  convertFromStringToDate,
  sendDirectMessage,
};
