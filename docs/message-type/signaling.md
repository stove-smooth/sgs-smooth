# 시그널링 서버 메세지 타입

## 메세지 타입 예제
- 모든 메세지는 아래 양식을 따름.
    ```json
    {
        "id": "{Evnet_ID}",
        "property1": "property1_content",
        "property2": "property2_content",
        ...
    }
    ```
- 메세지는 `id`를 가지고 있고, `id`를 기준으로 이벤트를 처리
- 각 이벤트에 필요한 `property`는 메세지별 세부 정의를 확인

## 전체 메세지 ID 목록
### 요청 (클라이언트 -> 서버)
|  구분  |메세지 ID|설명|요청에 대한 응답 메세지|
|---|---|---|---|
|<b>req-1</b>|`joinRoom`|방 접속|새로운 유저: `existingParticipants`<br>기존 유저: `newParticipantArrived`|
|<b>req-2</b>|`receiveVideoFrom`|SDP 정보 전송|`receiveVideoAnswer`|
|<b>req-3</b>|`onIceCandidate`|ICE Candidate 정보 전송|`iceCandidate`|
|<b>req-4</b>|`leaveRoom`|방 나가기|`participantLeft`|
|<b>req-5</b>|`videoStateFrom`|비디오 설정 변경|`videoStateAnswer`|
|<b>req-6</b>|`audioStateFrom`|오디오 설정 변경|`audioStateAnswer`|


### 응답 (서버 -> 클라이언트)
|  구분  |메세지 ID|설명|
|---|---|---|
|<b>res-1</b>|`existingParticipants`|방에 접속한 유저의 명단|
|<b>res-2</b>|`newParticipantArrived`|새로운 유저 입장|
|<b>res-3</b>|`receiveVideoAnswer`|SDP 정보 전송에 대한 응답|
|<b>res-4</b>|`iceCandidate`|ICE Candidate 정보 전송|
|<b>res-5</b>|`participantLeft`|유저 나감|
|<b>res-6</b>|`videoStateAnswer`|화면 설정 변경에 대한 응답|
|<b>res-7</b>|`audioStateAnswer`|오디오 설정 변경에 대한 응답|


## 메세지 세부 정의
### req-1 : 방 접속
|Property|Type|Description|Default|
|---|---|---|---|
|id|String|이벤트 아이디|`joinRoom`|
|token|String|엑세스토큰||
|userId|String|유저 아이디||
|communityId|String|커뮤니티 아이디|DM의 경우 `0`|
|roomId|String|채널 아이디<br>- 커뮤니티 내 음성 채널일 경우 : c-{channelId} (ex. c-10)<br>- DM일 경우 : r-{roomId} (ex. r-5)||
|video|boolean|비디오 상태|`false`: 꺼짐, `true`: 켜짐|
|audio|boolean|오디오 상태|`false`: 꺼짐, `true`: 켜짐|

#### sample
```json
{
    "id": "joinRoom",
    "token": "128eqdioq90amx.d09sad192je0129.das9jd1j",
    "userId": "1",
    "communityId: "1",
    "roomId": "c-10",
    "video": false,
    "audio": false
}
```
---

### req-2 : SDP 정보 전송
|Property|Type|Description|Default|
|---|---|---|---|
|id|String|이벤트 아이디|`receiveVideoFrom`|
|userId|String|유저 아이디||
|sdpOffer|String|SDP 정보||

#### sample
```json
{
    "id": "receiveVideoFrom",
    "userId": "1",
    "sdpOffer" : "v=0\r\no=- 4993863236499815601 2 IN IP4 127.0.0.1\r\ns=-\r\nt=0 0\r\na=group:BUNDLE 0 1\r\na=extmap-allow-mixed\r\na=msid-semantic: WMS pm15AJDxqQxKcn1zx9PtI31hOCI6yV9bTEgx\r\nm=audio 9 UDP/TLS/RTP/SAVPF 111 63 103 104 9 0 8 106 105 13 110 112 113 126\r\nc=IN IP4 0.0.0.0\r\na=rtcp:9 IN IP4 0.0.0.0\r\na=ice-ufrag:aKkH\r\na=ice-pwd:sYPssR5Gs1iz7VeRPzhB2uKN\r\na=ice-options:trickle\r\na=fingerprint:sha-256 E8:D9:1E:40:69:14:D1:3D:25:10:3F:B1:E6:CA:CE:B5:C1:54:B1:0E:17:3C:B0:77:27:0E:7E:0F:B6:4A:5A:61\r\na=setup:actpass\r\na=mid:0\r\na=extmap:1 urn:ietf:params:rtp-hdrext:ssrc-audio-level\r\na=extmap:2 http://www.webrtc.org/experiments/rtp-hdrext/abs-send-time\r\na=extmap:3 http://www.ietf.org/id/draft-holmer-rmcat-transport-wide-cc-extensions-01\r\na=extmap:4..."
}
```
---

### req-3 : ICE Candidate 정보 전송
|Property|Type|Description|Default|
|---|---|---|---|
|id|String|이벤트 아이디|`onIceCandidate`|
|userId|String|유저 아이디||
|candidate|Object|candidate 정보||
|candidate.candidate|String|candidate 정보||
|candidate.sdpMid|String|candidate 식별 태그||
|candidate.sdpMLineIndex|int|candidate와 연결된 미디어 의미||

#### sample
```json
{
    "id": "onIceCandidate",
    "userId": "1",
    "candidate": {
        "candidate": "candidate:2776107695 1 udp 2122194687 192.168.0.137 64922 typ host generation 0 ufrag aKkH network-id 2 network-cost 10",
        "sdpMid": "0",
        "sdpMLineIndex": 0
    }
}
```
---

### req-4 : 방 나가기
|Property|Type|Description|Default|
|---|---|---|---|
|id|String|이벤트 아이디|`leaveRoom`|

#### sample
```json
{
    "id": "leaveRoom"
}
```
---

### req-5: 화면 설정 변경
|Property|Type|Description|Default|
|---|---|---|---|
|id|String|이벤트 아이디|`videoStateFrom`|
|userId|String|유저 아이디||
|video|String|ON/OFF 여부|`false`: 꺼짐, `true`: 켜짐|

#### sample
```json
{
    "id": "videoStateFrom",
    "userId": "1",
    "video": true
}
```
---

### req-6: 오디오 설정 변경
|Property|Type|Description|Default|
|---|---|---|---|
|id|String|이벤트 아이디|`audioStateFrom`|
|userId|String|유저 아이디||
|audio|boolean|ON/OFF 여부|`false`: 꺼짐, `true`: 켜짐|

#### sample
```json
{
    "id": "audioStateFrom",
    "userId": "1",
    "audio": true
}
```
---

### res-1 : 방에 접속한 유저의 명단
|Property|Type|Description|Default|
|---|---|---|---|
|id|String|이벤트 아이디|`existingParticipants`|
|members|List|방에 접속해 있는 유저들의 명단||
|members[i]|Object|유저 정보||
|members[i].userId|String|유저 아이디||
|members[i].video|boolean|비디오 상태|`false`: 꺼짐, `true`: 켜짐|
|members[i].audio|boolean|오디오 상태|`false`: 꺼짐, `true`: 켜짐|

#### sample
```json
{
    "id": "existingParticipants",
    "members": [
        {
            "userId": "2",
            "video": false,
            "audio": true
        },
        {
            "userId": "4",
            "video": true,
            "audio": true
        }
    ]
}
```
---

### res-2 : 새로운 유저의 접속
|Property|Type|Description|Default|
|---|---|---|---|
|id|String|이벤트 아이디|`newParticipantArrived`|
|member|Object|유저 정보||
|member.userId|String|새로 접속한 유저 아이디||
|member.video|String|비디오 상태|`false`: 꺼짐, `true`: 켜짐|
|member.audio|String|오디오 상태|`false`: 꺼짐, `true`: 켜짐|

#### sample
```json
{
    "id": "newParticipantArrived",
    "member": {
        "userId": "1",
        "video": false,
        "audio": true
    }
}
```

### res-3 : SDP 정보 전송에 대한 응답
|Property|Type|Description|Default|
|---|---|---|---|
|id|String|이벤트 아이디|`receiveVideoAnswer`|
|userId|String|유저 아이디||
|sdpAnswer|String|서버에 전송한 SDP 정보 확인||

#### sample
```json
{
    "id": "receiveVideoAnswer",
    "userId": "1",
    "sdpAnswer" :"v=0\r\no=- 3852684837 3852684837 IN IP4 0.0.0.0\r\ns=Kurento Media Server\r\nc=IN IP4 0.0.0.0\r\nt=0 0\r\na=extmap-allow-mixed:\r\na=msid-semantic: WMS pm15AJDxqQxKcn1zx9PtI31hOCI6yV9bTEgx\r\na=group:BUNDLE 0 1\r\nm=audio 1 UDP/TLS/RTP/SAVPF 111 0\r\na=extmap:2 http://www.webrtc.org/experiments/rtp-hdrext/abs-send-time\r\na=recvonly\r\na=mid:0\r\na=rtcp:9 IN IP4 0.0.0.0\r\na=rtpmap:111 opus/48000/2\r\na=rtpmap:0 PCMU/8000\r\na=setup:active\r\na=rtcp-mux\r\na=fmtp:111 minptime=10;useinbandfec=1\r\na=ssrc:1855102669 cname:user3868562591@host-b5558a2a\r\na=ice-ufrag:vR2M\r\na=ice-pwd:Znae2TR333giBk1GH4vOks\r\na=fingerprint:sha-256 ..."
}
```

### res-4 : ICE Candidate 정보 전송
|Property|Type|Description|Default|
|---|---|---|---|
|id|String|이벤트 아이디|`iceCandidate`|
|userId|String|유저 아이디||
|candidate|Object|candidate 정보||
|candidate.candidate|String|candidate 정보||
|candidate.sdpMid|String|candidate 식별 태그||
|candidate.sdpMLineIndex|int|candidate와 연결된 미디어 의미||

#### sample
```json
{
    "id": "iceCandidate",
    "userId": "1",
    "candidate": {
        "candidate": "candidate:2776107695 1 udp 2122194687 192.168.0.137 63192 typ host generation 0 ufrag hYKB network-id 2 network-cost 10",
        "sdpMid": "0",
        "sdpMLineIndex": 0
    }
}
```

### res-5 : 방 나가기
|Property|Type|Description|Default|
|---|---|---|---|
|id|String|이벤트 아이디|`participantLeft`|
|userId|String|유저 아이디||

#### sample
```json
{
    "id": "participantLeft",
    "userId": "1"
}
```

### res-6: 화면 설정 변경에 대한 응답
|Property|Type|Description|Default|
|---|---|---|---|
|id|String|이벤트 아이디|`videoStateAnswer`|
|userId|String|유저 아이디||
|video|boolean|ON/OFF 여부|`false`: 꺼짐, `true`: 켜짐|

#### sample
```json
{
    "id": "videoStateAnswer",
    "userId": "1",
    "video": true
}
```
---

### res-7: 오디오 설정 변경에 대한 응답
|Property|Type|Description|Default|
|---|---|---|---|
|id|String|이벤트 아이디|`audioStateAnswer`|
|userId|String|유저 아이디||
|audio|boolean|ON/OFF 여부|`false`: 꺼짐, `true`: 켜짐|

#### sample
```json
{
    "id": "audioStateAnswer",
    "userId": "1",
    "audio": true
}
```