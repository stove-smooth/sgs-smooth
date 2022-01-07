package com.example.communityserver.dto.response;

import com.example.communityserver.domain.type.ChannelStatus;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ThreadDetailResponse extends ThreadResponse {
    private UserResponse author;
    private LocalDateTime createdAt;
    @Enumerated(EnumType.STRING)
    private ChannelStatus status;
}
