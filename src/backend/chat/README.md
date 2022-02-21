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
![sample](https://github.com/stove-smooth/signaling/blob/main/assets/sample.gif?raw=true)
 
 ## 참고
- kafka 설명 : https://kafka.apache.org/documentation/#design_pull
- kafka 개념 : https://victorydntmd.tistory.com/344
- consumer group 이해 : https://www.popit.kr/kafka-consumer-group
- kafka 클러스터 구축 - https://team-platform.tistory.com/13
- 메세지 순서 이해 : https://www.popit.kr/kafka-%EC%9A%B4%EC%98%81%EC%9E%90%EA%B0%80-%EB%A7%90%ED%95%98%EB%8A%94-%EC%B2%98%EC%9D%8C-%EC%A0%91%ED%95%98%EB%8A%94-kafka/

