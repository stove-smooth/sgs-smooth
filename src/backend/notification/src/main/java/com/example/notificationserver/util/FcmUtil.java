package com.example.notificationserver.util;

import com.example.notificationserver.exception.CustomException;
import com.google.firebase.messaging.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.*;

import static com.example.notificationserver.exception.CustomExceptionStatus.MESSAGE_TYPE_ERROR;
import static com.example.notificationserver.util.MessageType.*;
@Component
@RequiredArgsConstructor
public class FcmUtil {

    private final FirebaseMessaging instance;

    private final static String CID = "communityId";
    private final static String RID = "channelId";

    // 단일 전송 메세지 만들기
    public Message makeMessage(String targetToken, String title, String body, String image, String platform, Map<String, String> data) throws FirebaseMessagingException {
        Notification notification = Notification
                .builder()
                .setTitle(title)
                .setBody(body)
                .setImage(image).build();

        Message.Builder messageBuilder = Message.builder();
        messageBuilder.setToken(targetToken);
        messageBuilder.setNotification(notification);
        if (platform.equals(DeviceType.WEB)) {
            messageBuilder.setWebpushConfig(makeWebpushConfig(data));
        } else {
            messageBuilder.setApnsConfig(makeApnsConfig(data));
        }
        return messageBuilder.build();
    }

    // 일괄 전송 메세지 만들기
    public MulticastMessage makeMessage(List<String> targetTokens, String title, String body, String image, String platform, Map<String, String> data) throws FirebaseMessagingException {
        Notification notification = Notification
                .builder()
                .setTitle(title)
                .setBody(body)
                .setImage(image).build();

        MulticastMessage.Builder messageBuilder = MulticastMessage.builder();
        messageBuilder.addAllTokens(targetTokens);
        messageBuilder.setNotification(notification);
        if (platform.equals(DeviceType.WEB)) {
            messageBuilder.setWebpushConfig(makeWebpushConfig(data));
        } else {
            messageBuilder.setApnsConfig(makeApnsConfig(data));
        }
        return messageBuilder.build();
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

    // custom data 만들기
    public Map<String, String> makeCustomData(Long communityId, Long channelId) {
        Map<String, String> customData = new HashMap<>();
        String cid = Objects.isNull(communityId) ? "0" : communityId.toString();
        String rid = channelId.toString();
        customData.put(CID, cid);
        customData.put(RID, rid);
        return customData;
    }

    private WebpushConfig makeWebpushConfig(Map<String, String> data) {
        String cid = data.get(CID);
        String rid = data.get(RID);
        WebpushConfig.Builder webpushConfigBuilder = WebpushConfig.builder();
        Optional.ofNullable(data).ifPresent(sit -> webpushConfigBuilder.putAllData(sit));
        String link = "/channels/" + (cid.equals("0") ? "@me" : cid) + "/" + rid;
        webpushConfigBuilder.setFcmOptions(WebpushFcmOptions.withLink(link));
        return webpushConfigBuilder.build();
    }

    private ApnsConfig makeApnsConfig(Map<String, String> data) {
        ApnsConfig.Builder apnsConfigBuilder = ApnsConfig.builder();
        Aps.Builder apsBuilder = Aps.builder();
        Map<String, Object> map = new HashMap<>();
        for (Map.Entry<String, String> entry: data.entrySet()) {
            map.put(entry.getKey(), entry.getValue());
        }
        Optional.ofNullable(map).ifPresent(sit -> apsBuilder.putAllCustomData(sit));
        apnsConfigBuilder.setAps(apsBuilder.build());
        Optional.ofNullable(map).ifPresent(sit -> apnsConfigBuilder.putAllCustomData(sit));
        return apnsConfigBuilder.build();
    }
}
