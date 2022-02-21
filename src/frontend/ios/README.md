<img width = "450" alt="image" src="https://github.com/stove-smooth/sgs-smooth/blob/feature/dr/src/frontend/ios/docs/assets/smooth-main.png">

# smooth-iOS

- [Overview](#overview)
- [사용 기술 및 라이브러리](#사용-기술-및-라이브러리)
- [기술스택](#기술스택)
- [화면](#화면)
- [개발일지](#개발일지)
- [](#실행하기)
---
<br>

### Overview
>  다양한 상황(또는 화면)에서 Rx를 통해 비동기 처리를 이해하며 적용해보고, 실시간 통신을 바탕으로 다양한 모듈(또는 기능)을 구조화 하는 것에 중점을 두고 프로젝트 개발하였습니다.

<br>

```
- 프로젝트 주제 : 디스코드 클론!
- 주요 기능 : 실시간 채팅, 실사긴 음성/화상 채팅
```
<br>


<br>

### 사용 기술 및 라이브러리
<img src="https://img.shields.io/badge/Swift-5.5-orange.svg" alt="Swift 5.5"> <img src="https://img.shields.io/badge/Xcode-13.2.1-blue.svg">
<img src="https://img.shields.io/badge/CocoaPod-1.11.3-red.svg">

#### Rx
- `RxSwift` : Swift에 Rx 문법을 결합시키기 위해 사용
- `RxCocoa` : Rx와 Cocoa framework를 결합하기 위해 사용
- `RxDataSource` : Observable 객체들을 Table/Collection View에서 유연하게 + 커스템 셀을 사용하기 위해 사용
- `RxGeusture` : UI 컴포넌트에 event control을 추가 하기 위해 사용

#### Network
- `Moya` : 네트워크 레이어의 간결성을 위해 사용 (moya를 통한 네트워크 탬플릿화)
- `StompClientLib` : 채팅 통신(Stomp 프로토콜 사용)

#### Image
- `Kingfisher` : 이미지 캐싱

#### UI
- `Snapkit` : AutoLayout을 쉽게 사용하기 위해 사용 (스토리보드 사용 지양)
- `Then` : UI 가독성 개선
- `PanModal` : modal창을 쉽게 구현하기 위해 사용
- `Toast-Swift` : toast 팝업 
- `MessageKit` : message UI
<br><br>

### 기술스택
- MVVM+Coordinator
<img width="600" alt="image" src="https://user-images.githubusercontent.com/26545623/153773438-46ce820a-8686-432c-8162-4cdaa3a69895.png">

- Concep 
1. 디자인 패턴에 의해 바탕이 되는 흐름들은 `Base`로 미리 정의한다. 
2. View/ViewController는 ViewModel에 의존하며, 값을 변경하거나 전달 해야할 때 Rx를 사용을 지향한다.
    - 스토리보드 사용을 지양하여, View 코드가 길어지는 경우 파일을 분리하여 작성한다.
3. 화면의 전환은 Coordinator를 이용한다. 
4. ViewModel은 `input`과 `output`으로 분리하여 관리한다. 
    - 화면에 따라 `model`를 별도로 관리한다.
    - `input` : 버튼의 탭 이벤트, 텍스트 필드의 입력 이벤트 등
        - State(UI 상태 값) : Driver/Subject
    - `output` : view에 넘겨 줄 데이터들 
        - 필요한 구독 시점에 따라 : (Publish/Relay) Subject  
<br><br>

### 디렉토리 구조
```
smooth-ios 
│   ├── Modules : 화면 단위
│   ├── Service : 네트워크 레이어 구현체
│   ├── API : 네트워크 레이어
│   ├── Model : Entity
│   ├── Coordinator : 일종의 라우터 
│   ├── Base : MVVM 패턴에 의해 공통적으로 사용하는 파일들
│   ├── Common : 프로젝트 기본 구성파일
└── └── Utils : 자주 사용하는 기능들을 커스텀한 파일
        ├── UserDefault, Alert ... Utils files
        └── Extension : 퍼스트파티 커스텀한 파일들
```
### 화면
- [시연 영상](https://github.com/stove-smooth/sgs-smooth/blob/feature/dr/src/frontend/ios/docs/%EC%8B%9C%EC%97%B0%20%EC%98%81%EC%83%81.md)

### 개발일지
- [notion](https://doitduri.notion.site/7ea66898d85e4679bfd4773471de6eef?v=f6ea07e4a18145f4af8e5f8568c3a2c4) (개발 몰입기간에는 일지가 많이 빠져있습니다.)
- 주차별 요약(표로)

----
### 실행하기
#### Cocoapods
```bash
$ cd ~/src/frontend/ios
$ pod install
```

```bash 
$ open smooth-ios.xcworkspace 
```

### Author
김두리, doitduri@gmail.com
