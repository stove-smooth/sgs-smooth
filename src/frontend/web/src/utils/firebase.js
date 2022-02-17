import firebase from "firebase/app";
import "firebase/messaging";
import { firebaseConfig } from "@/utils/firebaseConfig";
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
  return new Promise((resolve, reject) => {
    message
      .requestPermission()
      .then(() => {
        console.log("Notification permission granted.");
        return message
          .deleteToken()
          .catch(() => console.log("제거할 FCM TOKEN이 없습니다"));
      })
      .then((isDelete) => {
        console.log("FCMTokeon Deleted", isDelete);
        resolve(message.getToken());
      })
      .catch((err) => {
        reject(err);
      });
  });
}
//포그라운드 메시지
message.onMessage(({ notification }) => {
  const { title, body, click_action } = notification;
  console.log("[PUSH] onMessage: ", `${title} ${body} ${click_action}`);
  // alert(`${title} ${body}`);
  const options = {
    body: body,
    icon: "/smooth_discord.jfif",
    title: title,
    data: `localhost:3000${click_action}`,
  };
  new Notification(title, options);
});

export { getToken };
