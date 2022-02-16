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
//포그라운드 메시지는 사용하지 않을 예정
message.onMessage(({ notification }) => {
  console.log(notification);
  /* const { title, body } = notification;
  console.log("[PUSH] onMessage: ", `${title} ${body}`);
  // alert(`${title} ${body}`);
  const options = {
    body: body,
    icon: "/mococo.png", //s3처럼 따로 url 안쓰면 edge는 안보임
    // icon: "/favicon.ico",
  };
  new Notification(title, options); */
});

export { getToken };
