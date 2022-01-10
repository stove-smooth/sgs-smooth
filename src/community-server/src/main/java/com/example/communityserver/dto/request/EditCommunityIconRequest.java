package com.example.communityserver.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.constraints.NotNull;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class EditCommunityIconRequest {

    @NotNull
    private Long communityId;

    @NotNull
    private MultipartFile icon;

    @NotNull
    private MultipartFile thumbnail;
}
