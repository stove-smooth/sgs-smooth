package com.example.communityserver.dto.response;

import com.example.communityserver.domain.type.CommunityRole;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.EnumType;
import javax.persistence.Enumerated;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UserDetailResponse extends UserResponse {
    private String bio;
    private String state;
    @Enumerated(EnumType.STRING)
    private CommunityRole role;
    private String memo;
}
