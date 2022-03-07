import store from "@/store/index";
import { createDirectMessage } from "@/api/index.js";
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

      canvas.width = 350;
      canvas.height = 350;

      canvasContext.drawImage(this, 0, 0, 350, 350);

      dataURI = canvas.toDataURL("image/jpeg");
      thumbnail = dataURI;
      resolve(thumbnail);
    };
  });
}
//이미지를 썸네일로 변환한다.
async function converToThumbnail(image) {
  const result = await processFile(image);
  return await processFile2(result);
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
  const categories = communityInfo.categories;
  for (var category in categories) {
    if (categories[category].channels != null) {
      for (let channel of categories[category].channels) {
        if (channel.id == id) {
          return channel.name;
        }
      }
    }
  }
}

async function sendDirectMessage(directMessageList, userId) {
  for(let message of directMessageList){
    if (!message.group&&message.members.includes(userId)) {
      return message.id;
    }
  }
  const dmMembers = {
    members: [userId],
  };
  const result = await createDirectMessage(dmMembers);
  return result.data.result.id;
}

function clickPlusAction(event){
  const x = event.clientX;
  const y = event.clientY;
  store.commit("utils/setClientX",x);
  store.commit("utils/setClientY",y);
}

function closeMemberPlusMenu(e){
  let condition=e.target.className;
  const isMemberContainer = ["friends-name","avatar-wrapper","primary-member-layout","friends-name-decorator"].includes(condition);
  if (!isMemberContainer) {
    store.commit("community/setCommunityMemberPlusMenu",null);
  }
}

export {
  clickPlusAction,
  selectProfile,
  converToThumbnail,
  dataUrlToFile,
  computeChannelName,
  sendDirectMessage,
  closeMemberPlusMenu,
};
