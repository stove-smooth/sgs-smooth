package com.example.notificationserver.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import javax.validation.constraints.NotNull;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class DirectMessageRequest {

    @NotNull
    private Long userId;

    @NotNull
    private String username;

    @NotNull
    private String type;

    @NotNull
    private String content;

    @NotNull
    private String roomName;

    @NotNull
    private Long roomId;

    @NotNull
    private String target;
}
