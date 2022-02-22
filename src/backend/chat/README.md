# 채팅 서버

## 역할
|서비스|역할|
|---|---|
|채팅 서버|- 채팅 서비스를 제공하기 위해 웹 소켓을 이용해 서버와 클라이언트간 통신<br>- 채팅과 동시에 하나의 로비 역할을 담당<br>- 사용자의 세션값을 토대로 상태 정보값을 TCP를 통해 상태관리 서버로 전송|


## 기술스택
- Java 11
- Springboot 2.6.2
- WebSocket, SockJS
- Spring Integration TCP/UDP
- kafka
- jwt
- Redis
- mongo DB

## 아키텍처

![image](https://user-images.githubusercontent.com/66015002/154964357-6f9cccf1-896a-4511-97b5-29551480a697.png)


## 제공 기능
|기능|설명|
|---|---|
|채팅 crud | 기본적인 채팅 및 답장 기능|
|웹 어플리케이션 <br> 로비 기능 | - 소켓 interceptor를 통해 connect, disconnect를 토대로 사용자의 online,offline을 판단|
|kafka를 이용한 다중 채팅 서버 | - 메세지 브로커를 이용한 다중 채팅 서버 동기화 작업 <br> - type 정의를 통한 kafka sender ,listener 로직|

## 구현
### 1. 웹소켓 inteteptor 핸들링

- [FilterChannelInterceptor.java](.src/backend/chat/src/main/java/com/example/chatserver/config/FilterChannelInterceptor.java)
 ```java
    public class FilterChannelInterceptor implements ChannelInterceptor {

    ...

    @Override
    public Message<?> preSend(Message<?> message, MessageChannel channel) {
        StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(message);
        if (StompCommand.CONNECT.equals(headerAccessor.getCommand())) {
            if (!jwtTokenFilter.isJwtValid(Objects.requireNonNull(headerAccessor.getFirstNativeHeader("access-token")))) {
                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
            }
        }
        return message;
    }

    @Override
    public void postSend(Message<?> message, MessageChannel channel, boolean sent) {
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(message);
        switch (accessor.getCommand()) {
            case CONNECT:
                String session_id = accessor.getSessionId();
                String user_id = Objects.requireNonNull(accessor.getFirstNativeHeader("user-id"));
                LoginSessionRequest loginSessionRequest = LoginSessionRequest.builder()
                                .type("login")
                                .session_id(session_id).user_id(user_id).build();
                tcpClientGateway.send(loginSessionRequest.toString());

                List<String> roomList = communityClient.getRoomList(Long.valueOf(user_id));
                StateRequest stateRequest = StateRequest.builder()
                        .type("connect")
                        .userId(user_id)
                        .ids(roomList).build();
                messageSender.signaling(stateTopic,stateRequest);
                break;
            case DISCONNECT:
                String sessionId = accessor.getSessionId();
                LoginSessionRequest logoutSessionRequest = LoginSessionRequest.builder()
                                .type("logout")
                                .session_id(sessionId).build();
                String id = tcpClientGateway.send(logoutSessionRequest.toString());
                
                ...
                
                break;
            default:
                break;
        }
    }
    ...
}
```
### 2. 메세지 브로커(Kafka)를 이용한 다중 채팅 서버
- 기능별 Topic를 생성하여 관리합니다.
- Topic 별 Consumer Group을 생성합니다.
  - 서버별 Consumer Group Id를 달리합니다.
 
|Topic|설명|
|---|---|
|chat-topic | DM 채팅을 위한 토픽|
|direct-topic | - 커뮤니티 채팅을 위한 토픽|
|etc-direct-topic | - DM 부가 기능을 위한 토픽|
|etc-community-topic | - Community 부가 기능을 위한 토픽|
|file-topic | - 파일 업로드를 위한 토픽|
|state-topic | - 시그널링 상태를 위한 토픽|

|Consumer Group|설명|
|---|---|
|direct-server-group | DM 채팅을 위한 그룹|
|channel-server-group | - 커뮤니티 채팅을 위한 그룹|
|direct-etc-server-group | - DM 부가 기능을 위한 그룹|
|channel-etc-server-group | - Community 부가 기능을 위한 그룹|
|file-server-group | - 파일 업로드를 위한 그룹|
|state-group | - 시그널링 상태를 위한 그룹|

- [MessageSender.java](./src/backend/chat/src/main/java/com/example/chatserver/kafka/MessageSender.java)

 ```java
    public class MessageSender {

    ...

    public void sendToDirectChat(String topic, DirectMessage directChat) {
        
        ...
        // Direct Message 전송
        kafkaTemplateForDirectMessage.send(topic, save);
    }

    public void sendToChannelChat(String topic,ChannelMessage channelMessage) {
    
        ...
        // Community Message 전송
        kafkaTemplateForDirectMessage.send(topic,result);
    }
     public void sendToEtcDirectChat(String topic, DirectMessage directChat) {
        switch (directChat.getType()) {
            case "reply": {
                ...
                // Direct Message 답장 기능
                kafkaTemplateForDirectMessage.send(topic,result);
                break;
            }
            case "modify": {
                ...
                // Direct Message 답장 기능
                kafkaTemplateForDirectMessage.send(topic,result);
                break;
            }
            case "delete": {
                ...
                // Direct Message 답장 기능
                kafkaTemplateForDirectMessage.send(topic,result);
                break;
            }
        }
    }
    public void sendToEtcChannelChat(String topic, ChannelMessage channelMessage) {
        switch (channelMessage.getType()) {
            case "reply": {
                ...
                // Community Message 답장 기능
                kafkaTemplateForChannelMessage.send(topic,result);
                break;
            }
            case "modify": {
                ...
                // Community Message 수정 기능
                kafkaTemplateForChannelMessage.send(topic,result);
                break;
            }
            case "delete": {
                ...
                // Community Message 삭제 기능
                kafkaTemplateForChannelMessage.send(topic,result);
                break;
            }
        }
    }

    // 파일 업로드
    public void fileUpload(String topic, FileUploadResponse fileUploadResponse) {
        kafkaTemplateForFileUpload.send(topic,fileUploadResponse);
    }

    // 시그널링 상태
    public void signaling(String topic, StateRequest stateRequest) {
        kafkaTemplateForSignaling.send(topic,stateRequest);
    }
 ```
 
 
## 작동 화면
- 다중 채팅 서버(chat-server1, chat-server2, chat-server3)를 이용한 채팅 데모 화면입니다.

![sample](https://github.com/stove-smooth/sgs-smooth/blob/develop/docs/assets/web-demo/community/community-chatting-channel.gif)
 
 
## 프로젝트 진행 중 이슈
### Chat server에 TCP Client 포트를 연결시키면 EC2 서버가 터지는 현상
- local 환경에서 작동했을 때 아무 이상이 없지만, EC2 서버에서만 연결이 끊키는 현상이 발생
- 이에 대한 해결방법으로 ec2 cpu 점유율과 heap memory를 확인하였음

> 1. EC2 모니터링을 통해 현재 CPU 점유율 확인
- 사용량 90%를 웃도는 것을 확인
- t2.micro core 수는 1개


> 2. Heap memory 확인
- java.lang.OutOfMemoryError: Java heap space 오류 확인
- t2.micro에서 JVM 힙메모리 명령어 입력
```
[Linux]
java -XX:+PrintFlagsFinal -version 2>&1 | grep -i -E 'heapsize|permsize|version'

    uintx ErgoHeapSizeLimit                         = 0                                   {product}
    uintx HeapSizePerGCThread                       = 87241520                            {product}
    uintx InitialHeapSize                          := 16777216                            {product}
    uintx LargePageHeapSizeThreshold                = 134217728                           {product}
    uintx MaxHeapSize                              := 260046848                           {product}
```

- 램 1G의 t2.micro 서버의 Max heap memory는 256mb 

- 기본적으로 default는 max heap size는 해당 서버의 메모리의 25프로
- min heap size는 16분의 1 정도의 사이즈
- 2기가 메모리로 옮긴다고 가정시 500mb 메모리를 최대 힙메모리로 갖게 됨.<br>따라서 기존 인스턴스의 최대 메모리 사이즈를 늘리는 것이 적절하다고 판단
- 힙 메모리를 512m로 증가 후 다시 배포
```
-Xms512m -Xmx512m
```

> 3. 해결 되는가 싶었지만, 지속적인 서버 down 현상 발견

- SWAP 메모리 지정하는 방안 선택
  - SWMAP 메모리란?  RAM이 부족할 경우, HDD의 일정공간을 마치 RAM처럼 사용하는 것.

- SWAP 공간 크기 계산


 |물리적 RAM양|권장 스왑 공간|
|---|---|
|RAM 2G 이하| RAM 용량의 2배(최소 32m)|
|RAM 2G 초과| 4GB + (RAM-2GB)|

```
// dd 명령어로 swap 메모리 할당
sudo dd if=/dev/zero of=/swapfile bs=128M count=16

// 스왑 파일에 읽기, 쓰기 권한 할당
sudo chmod 600 /swapfile

// 스왑 영역 설정
sudo mkswap /swapfile

// 스왑 공간에 스왑 파일 추가
sudo swapon /swapfile

// 성공 여부 확인
sudo swapon -s

// 부팅 시 스왑 파일 활성화
sudo vi /etc/fstab

// 파일 끝에 다음 줄 새로 추가하고 파일 저장한 뒤 종료
/swapfile swap swap defaults 0 0

```
적용 후 테스트.....
- 채팅 서버의 속도가 눈에 띄게 낮아진 것을 확인

> 4. t2.medium으로 변경
- 램 1G t2.micro는 한계가 있는 것으로 판단

### Chat Server 여러개를 연동 시킬 때 kafka가 끊키는 현상
> 1. chat server 1,2,3 가동
- 기능별 다른 topic명 설정
- 기능별 다른 consumer group명 설정

> 2. 메세지 10개를 보내면 3~4개가 오는 것을 확인
- kafka properties 파일 확인
- zookeeper 재가동
- kafka 로그 삭제 후 재가동

> 3. kafka producer console 확인
- producer는 10개 메세지 전부 보내는 것을 확인

> 4. kafka consumer console 확인
- 채팅 서버 3개에 모두 찍혀야 할 로그가 분산되게 찍히는 것을 확인
- kafka consumer에 문제가 있는 것을 파악

> 5. kafka consumer group 확인
- 지정한 consumer group이 채팅 서버 3대가 모두 같은 것을 사용하고 있음을 파악
- consumer group을 서버 3대가 모두 점유하고 있으므로 메세지 또한 분산 되게 찍히는 것을 인지
- consumer group name을 서버별 증가되는 숫자 값을 추가하여 설정

> 6. consumer console 확인
- 해결 완료
- consumer group name을 서버 별로 달리 해야 되는 것을 배움
 
 ## 참고
- kafka 설명 : https://kafka.apache.org/documentation/#design_pull
- kafka 개념 : https://victorydntmd.tistory.com/344
- consumer group 이해 : https://www.popit.kr/kafka-consumer-group
- kafka 클러스터 구축 - https://team-platform.tistory.com/13
- 메세지 순서 이해 : https://www.popit.kr/kafka-%EC%9A%B4%EC%98%81%EC%9E%90%EA%B0%80-%EB%A7%90%ED%95%98%EB%8A%94-%EC%B2%98%EC%9D%8C-%EC%A0%91%ED%95%98%EB%8A%94-kafka/

