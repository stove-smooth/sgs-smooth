package com.example.communityserver.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotNull;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class LocateChannelRequest {
    @NotNull
    private Long id;
    @NotNull
    private Long categoryId;
    @NotNull
    private Long next;
}
