# 상태관리 서버

## 역할
|서비스|역할|
|---|---|
|상태관리 서버|- 채팅, 시그널링, 커뮤니티 룸 서버로 부터 들어오는 실시간 데이터를 저장, 관리를 담당|

## 기술스택
- Java 11
- Springboot 2.6.2
- Spring Integration TCP/UDP
- Redis

## 제공 기능
|기능|설명|
|---|---|
|실시간 유저 정보 저장|- 채팅 서버로부터 들어오는 유저 session, userId 값을 관리, 저장<br>- 채팅 서버로부터 들어오는 유저의 현재 위치값(방 정보) 관리, 저장<br>- 시그널링 서버로 부터 들어오는 소켓 session값, 유저 연결 값 저장, 관리<br>- 커뮤니티 룸 서버로 부터 들어오는 커뮤니티 유저 상태값 저장, 관리|


## 구현
### 1. Spring Integration Server Config
- TCP Server를 위한 설정
- 메세지를 수신 받을 채널과 게이트웨이를 설정한다.
- [TcpServerConfig.java](.src/backend/presence/src/main/java/com/example/presenceserver/config/TcpServerConfig.java)

```java
    public class TcpServerConfig {

    ...

    // Nio Factory
    @Bean
    public AbstractServerConnectionFactory serverConnectionFactory() {
        TcpNioServerConnectionFactory tcpNioServerConnectionFactory = new TcpNioServerConnectionFactory(port);
        tcpNioServerConnectionFactory.setUsingDirectBuffers(true);
        tcpNioServerConnectionFactory.setSerializer(codec());
        tcpNioServerConnectionFactory.setDeserializer(codec());
        return tcpNioServerConnectionFactory;
    }

    // 메세지 수신 채널
    @Bean
    public MessageChannel inboundChannel() {
        return new DirectChannel();
    }
    
    // 게이트 웨이 설정
    @Bean
    public TcpInboundGateway inboundGateway(AbstractServerConnectionFactory serverConnectionFactory,
                                            MessageChannel inboundChannel) {
        TcpInboundGateway tcpInboundGateway = new TcpInboundGateway();
        tcpInboundGateway.setConnectionFactory(serverConnectionFactory);
        tcpInboundGateway.setRequestChannel(inboundChannel);
        return tcpInboundGateway;
    }

    // 직렬화, 역직렬화 코덱
    public ByteArrayCrLfSerializer codec() {
        ByteArrayCrLfSerializer crLfSerializer = new ByteArrayCrLfSerializer();
        crLfSerializer.setMaxMessageSize(204800000);
        return crLfSerializer;
    }
```

### 2. Spring Integration Endpoint
- 서비스를 메세징 시스템에 연결하기 위한 엔드포인트를 설정
- [TcpServerEndpoint.java](.src/backend/presence/src/main/java/com/example/presenceserver/config/TcpServerEndpoint.java)

```java
    public class TcpServerEndpoint {

    private final TcpService tcpService;

    @ServiceActivator(inputChannel = "inboundChannel", async = "true")
    public String process(String message) throws JsonProcessingException {
        return tcpService.processMessage(message);
    }
}
```
### 3. Spring Integration Server Config
- 메세지 타입을 지정하여, 수신 받는 메세지를 구분
- redis를 이용하여 데이터 I/O , 저장
- [TcpService.java](.src/main/java/com/example/presenceserver/service/TcpService.java)

```java
   public class TcpService {

    ...

    public String processMessage(String message) throws JsonProcessingException {
        LoginSessionRequest request = new Gson().fromJson(message,LoginSessionRequest.class);
        switch (request.getType()) {
            // 채팅 websocket connect시
            case "login": {
                ...
                tcpClientGateway.send(request.getUser_id() + SEP + ONLINE);
                break;
            }
            // 채팅 websocket disconnect 시
            case "logout": {
                ...
                return temp;
            }
            // 유저 위치값(방 이동시)
            case "state": {
                ...
                return lastRoom + SEP + place;
            }
            
            // 메세지 수신,미수신 처리
            case "direct":
            case "community": {
                ...
                return String.valueOf(check);
            }
            
            // 음성 채널 상태 정보값 수신
            case "before-enter": {
                ...
                return objectMapper.writeValueAsString(result);
            }
            
            // 음성 채널 입장시 상태값 저장
            case "enter": {
                ...
                return objectMapper.writeValueAsString(result);
            }
            
            // 시그널링 소켓 connect/disconnect
            case "signaling": {
                ...
                break;
            }
        }
        return "반환메세지";
    }
}

```
## 프로젝트 진행중 이슈
### 1. Server to Server socket connection
- 프로젝트 특성상 채팅서버, 시그널링 서버가 있으므로 기본적으로 client가 2개의 소켓을 물고있음
- 상태관리 서버까지 client에 소켓을 연결한다면 client에 최대 3개의 소켓 부하를 주게 됨
- chat server가 client와 기본적인 connection을 담당하고, 받아온 데이터를 상태관리 서버로 넘기는 방식 선택

> http vs socket
- session에 따른 유저값
- 유저 id에 따른 실시간 방 정보 값
- 시그널링 소켓 연결 값

실시간으로 값이 변경 될 때마다 HTTP call??

> server to server socket connection 필요성 확인

- websocket : tcp 간 connection error나면 재연결이 되지 않음, 비동기 처리 지원하지 않음
- Rsocket : 비동기 지원, 리액티브 프로그래밍, 러닝 커브가 높음
- vert.X : 비동기 네트워크, 러닝 커브가 너무 높음
- spring integration : spring 지원, pojo 지원, 비동기 지원, connection error시 재연결

> spring integraion 채택

- 상태관리 서버: TCP server
- 채팅 서버: TCP Client
- 시그널링 서버: TCP Client
- 커뮤니티 룸 서버: TCP Client


---
## 관련 자료
- [TCP 고민](https://github.com/stove-smooth/messaging)
- [Spring Integration](https://www.slideshare.net/WangeunLee/spring-integration-47185594)

## 참고
- spring integration tcp/udp : https://docs.spring.io/spring-integration/reference/html/ip.html
- Nio 이해 : https://jungwoon.github.io/java/2019/01/15/NIO-Network.html
- spring integration reference guide : https://docs.spring.io/spring-integration/reference/html/
- spring integration tcp/udp support : https://docs.spring.io/spring-integration/reference/html/ip.html#ip
- spring integration introduction (baeldung) : https://www.baeldung.com/spring-integration
    - adapter (endpoint summary) : https://docs.spring.io/spring-integration/docs/5.1.0.M1/reference/html/endpoint-summary.html
    - tcp adapter : https://docs.spring.io/spring-integration/docs/5.1.0.M1/reference/html/ip.html#tcp-adapters
    - web socket adapter : https://docs.spring.io/spring-integration/docs/5.1.0.M1/reference/html/web-sockets.html#web-socket-inbound-adapter
- spring integration tutorial : https://github.com/eugenp/tutorials/tree/master/spring-integration

- spring integration keyword : https://www.linkedin.com/pulse/spring-boot-spring-integration-baki-hayat
- spring integration example : https://github.com/spring-projects/spring-integration-samples
    - https://github.com/spring-projects/spring-integration-samples/blob/main/advanced/dynamic-tcp-client/src/main/java/org/springframework/integration/samples/dynamictcp/DynamicTcpClientApplication.java
- spring integration transaction : https://www.baeldung.com/spring-integration-transaction
- TCP 서버 만들기
    - server : https://gogo-jjm.tistory.com/57
    - client : https://gogo-jjm.tistory.com/58?category=854015
- TcpSendingMessageHandler 예제 : http://useof.org/java-open-source/org.springframework.integration.ip.tcp.TcpSendingMessageHandler
- 패킷 유실 시 TCP/UDP 현상 : https://thebook.io/006884/ch02/07/
