package com.example.communityserver.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class CreateCommunityRequest {

    @NotEmpty
    @Size(min = 1, max = 100, message = "name min 1 max 100")
    private String name;

    @NotNull
    private boolean isPublic;

    @NotNull
    private MultipartFile icon;
}
