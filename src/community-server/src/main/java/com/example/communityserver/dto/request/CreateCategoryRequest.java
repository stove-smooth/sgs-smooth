package com.example.communityserver.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CreateCategoryRequest {

    @NotNull
    private Long communityId;

    @NotNull
    @Size(min = 1, max = 100, message = "name min 1 max 100")
    private String name;

    @NotNull
    private boolean isPublic;

    private List<Long> members;
}
