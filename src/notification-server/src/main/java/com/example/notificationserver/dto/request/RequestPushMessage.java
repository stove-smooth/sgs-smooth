package com.example.notificationserver.dto.request;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;
import java.util.Map;

@Getter
@Setter
@NoArgsConstructor
public class RequestPushMessage {
    private String title;
    private String body;
    private Map<String, String> data;
    private String image;
    private List<Long> userNos;

    @Builder
    public RequestPushMessage(String title, String body, Map<String, String> data, String image, List<Long> userNos) {
        this.title = title;
        this.body = body;
        this.data = data;
        this.image = image;
        this.userNos = userNos;
    }
}
