# Discord Clone - Smooth 

<a href="https://yoloyolo.org">
  <img src="./src/frontend/ios/docs/assets/smooth-main.png" width=100% />
</a>

---

## 1. 서비스 소개
- [디스코드 클론코딩](https://github.com/stove-smooth/sgs-smooth/wiki#%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8)
- [Web 세부 화면 보기](./docs/screen/detailPage.md)
- [iOS 세부 화면 보기](./src/frontend/ios/docs/시연%20영상.md)
---

## 2. 기술 스택
### Backend
- Java 11
- Spring Boot
- Spring MVC
- Spring Data JPA
- Spring Security
- Spring Cloud
- Spring Integration
- WebSocket, STOMP, SockJS
- Kafka, Zookeeper

### Frontend
#### Web
- Vue
- Javascript, HTML, CSS
- Kutento Util

#### iOS
- Swift
- MVVM + Coordinator

### Infrastructure
- MySQL
- MongoDB
- Redis
- Nginx
- Kurento Media Server
- AWS EC2, RDS, S3, CloudFront, ElastiCache
- Firebase Cloud Messaging
---

## 3. 프로젝트 구조
![image](https://user-images.githubusercontent.com/66015002/154006339-06a3c1a7-c840-445c-a616-eb1345468f2e.png)


---

## 4. 역할 분담

### Backend
#### [박병찬](https://github.com/qkrqudcks7)
- [채팅 서버](./src/backend/chat/)
- [상태관리 서버](./src/backend/presence/)
- [API Gateway](./src/infrastructure/gateway/)
- [유저 서버](./src/backend/auth/)

#### [김희동](https://github.com/ruthetum)
- [커뮤니티 서버](./src/backend/community/)
- [시그널링 서버](./src/backend/signaling/) + 미디어 서버
- [알림 서버](./src/backend/notification/)

### Frontend
#### [김민지](https://github.com/MINGDY98)
- [Web App(Vue)](./src/frontend/web/)

#### [김두리](https://github.com/doitduri)
- [iOS App](./src/frontend/ios/)

---

## 5. 디렉토리 구조
```
sgs-smooth
 ├── bin
 ├── config
 ├── deploy
 ├── docs
 ├── resources
 ├── scripts
 ├── src
 └── resources
```
|Directory|Description|
|------|-----|
|bin|실행 파일|
|config|설정 파일|
|deploy|배포 파일|
|docs|기능/설계, API 문서|
|scripts|스키마, 배치 파일|
|src|소스 코드|
|resources|템플릿, 폰트|
---

## 6. 커밋 컨벤션
| 메시지 | 설명 |
|:---:|:---:|
| feat | 새로운 기능 추가 |
| fix | 버그 수정|
| docs | 문서 추가 및 변경 |
| style | 코드 포맷팅 |
| refactor | 코드 리팩토링 |
| chore | 빌드 및 패키지 수정 |

---

## Contributors
<a href="https://github.com/stove-smooth/sgs-smooth/graphs/contributors">
  <img src="https://contributors-img.web.app/image?repo=stove-smooth/sgs-smooth">
</a>
