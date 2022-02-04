# Discord Clone - Smooth 

## 1. 서비스 소개
- [디스코드 클론코딩](https://github.com/stove-smooth/sgs-smooth/wiki#%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8)
---

## 2. 프로젝트 구조
![architecture](./docs/architecture/architecture.png)

---

## 3. 기술 스택
### Backend
- Java 11
- Spring Boot
- Spring Data JPA
- Spring Security
- Spring Cloud
- Spring Integration
- WebSocket, STOMP, SockJS
- Kafka, Zookeeper
- Kurento Media Server

### Frontend
#### Web
- Vue
- Javascript, HTML, CSS
- Kutento Util

#### [iOS](./src/frontend/ios/README.md)
- Swift
- MVVM + Coordinator

### Infrastructure
- MySQL
- MongoDB
- Redis
- Nginx
- AWS EC2, RDS, S3, CloudFront, ElastiCache
- Firebase Cloud Messaging
---

## 4. 디렉토리 구조
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

## 5. 커밋 컨벤션
| 메시지 | 설명 |
|:---:|:---:|
| feat | 새로운 기능 추가 |
| fix | 버그 수정|
| docs | 문서 추가 및 변경 |
| style | 코드 포맷팅 |
| refactor | 코드 리팩토링 |
| chore | 빌드 및 패키지 수정 |ㅠ