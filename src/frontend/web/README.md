# 🔈Smooth

<br>
<p align="center"><img src="https://user-images.githubusercontent.com/38098157/154839100-56534825-e24e-4d58-ae50-d3fcdcc97894.png" height="150px" width="150px"></p>

<div align="center">
  <img src="https://img.shields.io/badge/vue-4FC08D?style=flat-square&logo=vue.js&logoColor=white">
  <img src="https://img.shields.io/badge/vuex-61DAFB?style=flat-square&logo=vuex&logoColor=white"/>
  <img src="https://img.shields.io/badge/fcm-DB7093?style=flat-square&logo=fcm&logoColor=white"/><br>
  <img src="https://img.shields.io/badge/webSocket-339933?style=flat-square&logo=webSocket&logoColor=white"/>
  <img src="https://img.shields.io/badge/webRTC-000000?style=flat-square&logo=webRTC&logoColor=white"/>
</div>

<br>

## 🔈 배포 주소

<br>

[https://yoloyolo.org/](https://yoloyolo.org/)

 <br>

## 🔈 대표 실행화면

<br>

![커뮤니티 화상통화](../../../docs/assets/web-demo/voice/community-voice-chatting.gif)

<br>

## 🔈프로젝트 소개

<br>

> 스무스는 디스코드의 주요 기능을 클론코딩한 프로젝트입니다.<br>소규모 CRUD 프로젝트만 경험해본 상태에서 대규모 실시간 서비스 개발을 위한 다양한 기능의 사용을 경험해 보고싶어 도전하였습니다.

- 자세한 프로젝트 선택 배경은 다음을 참고해주세요.
  [디스코드 클론코딩](https://github.com/stove-smooth/sgs-smooth/wiki#%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8)

<br>

## 🔈기능 소개

<br>

다음과 같은 기능을 선정해 구현하였습니다.

| 커뮤니티 구현                              | 실시간 메시지 | 음성, 영상 채팅 |
| ------------------------------------------ | ------------- | --------------- |
| 커뮤니티, 카테고리, 채널 CRUD, 순서 바꾸기 | 그룹 메세지   | webRTC 연동     |
| 초대장 전송, URL 라우팅                    | 1:1 메세지    | 음성, 영상 제어 |

| 유저 상태 표현                 | 푸쉬 알림            |
| ------------------------------ | -------------------- |
| 실시간 타이핑 상태             | FCM을 통한 알림 수신 |
| 친구/멤버 온라인/오프라인 상태 | 메세지 counting      |
| 음성 채널 입장 상태            | 안 읽은 메세지 처리  |

<br>

## 🔈프로젝트 진행 중 이슈

<br>

> ### 실시간 채팅 이슈
> <br>

**1. 소켓 연결을 했음에도 구독한 메시지를 받을 수 없는 이슈**
<br>

- socket의 연결이 true가 되면, 구독한 메시지를 받을 수 있게끔 구현하였습니다. 로그인 직후 socket이 true가 되는데, 그 후에 네비게이션바를 통해 커뮤니티 채팅에 입장하니 구독한 메시지를 바을 수 없는 상황이 되었습니다.

```javascript
export const router = new VueRouter({
  mode: "history",
  routes: [
    {                                 //로그인 전
      path: "/login",
      name: "LoginPage",
      component: LoginPage,
    },
    {                                 //로그인 후
      path: "/",
      name: "MainPage",
      component: MainPage,
      children: [
        {
          path:,
          name:,
          component:,
        },
        ...
```

- 기존에 모든 라우트가 같은 level에 있는 단순 라우트 구조에서 트리 구조로 라우트 구조를 변경하였습니다.
- mainPage와 그 아래 페이지들은 로그인 후에만 입장이 가능하게 해서 로그인 전/후를 확실히 분리하였고, mainPage 아래 page로 입장시 구독한 메시지를 받을 수 있게 되었습니다.
- 또한, mainPage에 socket이 연결되었을때만 자식page가 렌더링되게 하여 socket이 연결되기 전에 채팅 페이지가 렌더링되어 채팅이 되지 않는 현상을 해결하였습니다.

<br>

**2. 이미지 채팅 불러온 후, 스크롤바가 아래로 가지 않는 이슈**
<br>

- 처음 채팅방 입장시 이미지 채팅 크기만큼 스크롤바가 아래로 가지 않는 현상이 있었습니다.
- 이 문제는 채팅 데이터를 받더라도 이미지 링크를 이미지로 변환하는데 별도의 통신이 발생되기에 발생하는 문제였습니다.
- 이미지 로딩이 완료되기 전, 이미지 크기만큼 스켈레톤 영역을 두어 이 문제를 해결하였습니다.
  <br>

> ### 실시간 화상 통화 이슈

![image](https://user-images.githubusercontent.com/38098157/154974424-12d2f757-2c0c-42f5-9b08-4e015c7535a0.png)

<br>

**1. 시그널링 메시지 전송, 수신 및 음성방 참가자 관리 이슈**
<br>

- 시그널링 메시지를 전송 및 수신을 하며 참가자 관리를 어떻게 할 수 있을지 고민하였습니다.
- 관련 로직을 Vuex에 등록하여, 시그널링 메시지 송수신에 따른 참가자 관리를 원할하게 하였습니다.
- 그래서 참가자가 변할 때마다 참가자 수를 고려하여 화면에 참가자들을 적절히 배치할 수 있었습니다.

**2. 비디오, 오디오 장치 변경 이슈**
<br>

- 기존의 Kurento Utils 사용으로는 다른 참가자의 비디오, 오디오 변경을 인지할 수 없었습니다.
- 비디오, 오디오에 관한 시그널링 메시지를 추가하여 사용자가 카메라와 오디오를 껐을 때의 화면 처리를 할 수 있게 되었습니다.

<br>

> ### 팝업 이슈

<br>

- 친구 추가 기능 버튼 클릭시 해당 영역 밖에 팝업을 띄워야 하는 문제가 있었습니다.
- 고민한 결과 버튼 클릭시의 마우스 좌표값을 받아 그것을 기준으로 팝업을 띄웠습니다.
  ![image](https://user-images.githubusercontent.com/38098157/154969417-a4b8f02e-6294-41d5-969b-3e2e0cb8f1c5.png)

- 또한, getBoundingClientRect() 메서드, offsetTop, offsetLeft 속성을 활용하여 선택된 객체 기준 좌표를 얻는 또다른 해결 방법을 알 수 있었습니다.

<br>

> ### vuex 구조에 관한 이슈

<br>

- 상태관리 라이브러리인 vuex를 처음 사용하고 얼마지나지 않아 구조 개선의 필요성을 느끼게 되었습니다.
- 초반에는 하나의 파일에서 관리했었는데, 너무 다양한 영역의 상태관리를 한번에 하다보니 파일이 복잡해지고 비대해져 사용이 어려워졌습니다.
- 1안 - state, mutation, actions의 분리 / 2안 - 기능별 분리중 vuex 구조를 어떻게 바꿀지 고민하였고, 스무스 프로젝트의 다양한 기능에 따라 2안을 채택하였습니다.

## 🔈 회고

```
새로운 도전의 경험이 쌓여 새로운 도전을 할 수 있는 힘을 길렀던 소중한 3개월이었습니다.
단순한 CRUD로 이루어진 프로젝트만 했고, 그 테두리에서만 생각을 해왔었는데 완전히 바뀌게 되었습니다.
webSocket, webRTC, 실시간 상태 관리, FCM 알림,, 모든 게 새로웠고 큰 어려움이었지만, 결국은 다 헤쳐왔습니다.
팀원들과 함께라면 이제는 못할 것이 아무것도 없다는 생각이 듭니다.
이러한 기회를 준 Stove Dev Camp, 그리고 우리 팀 Smooth께 모두 감사드립니다.
```

<br>

## 🔈 프로젝트 구조

<br>

```
│  App.vue
│  main.js
├─api
│  └─common
├─assets
├─components
│  ├─common
│  │  ├─Message
│  │  └─Voice
│  ├─Community
│  │  ├─Category
│  │  ├─Channel
│  │  └─Community
│  ├─DM
│  └─Friends
├─css
├─garbage
│  └─components
├─pages
├─routes
├─store
│  └─module
│      └─js
└─utils
```
#### 관련자료

https://velog.io/@pigu/%EC%8B%A4%EC%8B%9C%EA%B0%84-%EC%98%81%EC%83%81-%EC%84%9C%EB%B9%84%EC%8A%A4%EB%A5%BC-%EC%9C%84%ED%95%9C-%EA%B0%9C%EB%85%90-%EC%A0%95%EB%A6%AC
