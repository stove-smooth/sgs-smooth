package com.example.notificationserver.util;

import com.example.notificationserver.exception.CustomException;
import com.google.firebase.messaging.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

import static com.example.notificationserver.exception.CustomExceptionStatus.MESSAGE_TYPE_ERROR;
import static com.example.notificationserver.util.MessageType.*;

@Component
@RequiredArgsConstructor
public class FcmUtil {

    private final FirebaseMessaging instance;

    // 단일 전송 메세지 만들기
    public Message makeMessage(String targetToken, String title, String body, String image, Map<String, String> data) throws FirebaseMessagingException {
        Notification notification = Notification
                .builder()
                .setTitle(title)
                .setBody(body)
                .setImage(image).build();
        Message msg = Message
                .builder()
                .setToken(targetToken)
                .setNotification(notification).build();
        return msg;
    }

    // 일괄 전송 메세지 만들기
    public MulticastMessage makeMessage(List<String> targetTokens, String title, String body, String image, Map<String, String> data) throws FirebaseMessagingException {
        Notification notification = Notification
                .builder()
                .setTitle(title)
                .setBody(body)
                .setImage(image).build();
        MulticastMessage.Builder builder = MulticastMessage.builder();
        // Optional.ofNullable(data.getData()).ifPresent(sit -> builder.putAllData(sit));
        MulticastMessage msg = builder.addAllTokens(targetTokens).setNotification(notification).build();
        return msg;
    }

    // 단일 메시지 전송
    public String sendMessage(Message message) throws FirebaseMessagingException {
        return this.instance.send(message);
    }

    // 일괄 메시지 전송
    public BatchResponse sendMessage(MulticastMessage message) throws FirebaseMessagingException {
        return this.instance.sendMulticast(message);
    }

    // 제목 만들기
    public String makeTitle(String username, String channelName) {
        return username + " (" + channelName + ")";
    }

    // 바디 만들기
    public String makeBody(String type, String content) {
        if (type.equals(TEXT)) {
            return content;
        } else if (type.equals(IMAGE)) {
            return "사진이 전송되었습니다.";
        } else if (type.equals(VIDEO)) {
            return "비디오가 전송되었습니다.";
        } else if (type.equals(FILE)) {
            return "파일이 전송되었습니다.";
        }
        throw new CustomException(MESSAGE_TYPE_ERROR);
    }

    // 미리보기 이미지 만들기
    public String makeImage(String type, String content) {
        if (type.equals(IMAGE))
            return content;
        else
            return null;
    }
}
