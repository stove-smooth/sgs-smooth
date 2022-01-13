package com.example.communityserver.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class EditCommunityNameRequest {

    @NotNull
    private Long communityId;

    @NotNull
    @Size(min = 1, max = 100, message = "name min 1 max 100")
    private String name;
}
