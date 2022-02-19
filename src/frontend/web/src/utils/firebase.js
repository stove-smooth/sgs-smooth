import firebase from "firebase/app";
import "firebase/messaging";
import { firebaseConfig } from "@/utils/firebaseConfig";
import store from "../store/index";
import { fetchDirectMessageMemberList } from "../api";
// 서비스 워크 등록
navigator.serviceWorker
  .register("/firebase-messaging-sw.js")
  .then((registration) => {
    console.log("serviceWorker registration");
    return message.useServiceWorker(registration);
  });
firebase.initializeApp(firebaseConfig);

const message = firebase.messaging();

function getToken() {
  return new Promise((resolve) => {
    message
      .getToken()
      .then((currentToken) => {
        if (currentToken) {
          console.log("current token : " + currentToken);
          resolve(currentToken);
        } else {
          console.log("currentToken이없음");
        }
      })
      .catch((e) => {
        console.log(e);
      });
  });
}
//     .requestPermission()
//     .then(() => {
//       console.log("Notification permission granted.");
//       return message.deleteToken();
//     })
//     .then((isDelete) => {
//       console.log("FCMTokeon Deleted", isDelete);
//       resolve(message.getToken());
//     })
//     .catch((err) => {
//       reject(err);
//     });
// });

//포그라운드 메시지
message.onMessage(async (payload) => {
  const { data, notification } = payload;

  const options = {
    body: notification.body,
    icon: "/smooth_discord.jfif",
    title: notification.title,
    data: `localhost:3000${notification.click_action}`,
  };
  if (data.communityId == 0) {
    const dmlist = store.getters["dm/getDirectMessageList"]; //dmlist
    //navigationbar rooms 알림에 있는 사람이 계속 말 걸 경우 + rooms도 올라가야함 + 채팅방이 올라가야함.
    const communityList = store.getters["community/getCommunityList"];
    for (let i = 0; i < communityList.rooms.length; i++) {
      if (communityList.rooms[i].id == data.channelId) {
        communityList.rooms[i].count++;
        if (i != 0) {
          //알림온 dm이 navigationbar에서 최상단이 아닐경우. 바꿔준다.
          let roomUpdated = communityList.rooms.splice(i, 1);
          communityList.rooms.unshift(roomUpdated[0]);
          //dm 도 최상단으로 갑니다.
        }
        if (dmlist) {
          for (let i = 0; i < dmlist.length; i++) {
            if (dmlist[i].id == data.channelId) {
              let dmUpdated = dmlist.splice(i, 1);
              dmlist.unshift(dmUpdated[0]);
              return;
            }
          }
        }
        return;
      }
    }
    //navigationbar rooms 목록에 없는 경우 생겨야 함.
    const result = await fetchDirectMessageMemberList(data.channelId);

    let newAddlist = {
      count: 1,
      icon: result.data.result.icon,
      id: result.data.result.id,
      name: result.data.result.name,
    };
    communityList.rooms.unshift(newAddlist);

    //dm 도 최상단으로 갑니다.
    if (dmlist) {
      for (let i = 0; i < dmlist.length; i++) {
        if (dmlist[i].id == data.channelId) {
          let dmUpdated = dmlist.splice(i, 1);
          dmlist.unshift(dmUpdated[0]);
          return;
        }
      }
    }
  }
  new Notification(notification.title, options);
});

export { getToken };
