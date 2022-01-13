package com.example.communityserver.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CreateCommunityRequest {

    @NotNull
    @Size(min = 1, max = 100, message = "name min 1 max 100")
    private String name;

    @NotNull
    private boolean isPublic;

    private MultipartFile icon;
}
