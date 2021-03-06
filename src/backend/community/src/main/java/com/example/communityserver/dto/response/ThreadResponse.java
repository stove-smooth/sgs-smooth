package com.example.communityserver.dto.response;

import com.example.communityserver.domain.Channel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ThreadResponse {
    private Long id;
    private String name;

    public static ThreadResponse fromEntity(Channel channel) {
        ThreadResponse threadResponse = new ThreadResponse();
        threadResponse.setId(channel.getId());
        threadResponse.setName(channel.getName());
        return threadResponse;
    }
}
