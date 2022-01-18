package com.example.communityserver.dto.request;

import com.example.communityserver.domain.type.ChannelType;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CreateChannelRequest {

    @NotNull
    private Long id;

    @NotNull
    @Size(min = 1, max = 100, message = "name min 1 max 100")
    private String name;

    @NotNull
    private boolean isPublic;

    @NotNull
    @Enumerated(EnumType.STRING)
    private ChannelType type;

    private List<Long> members;
}
