package com.example.communityserver.dto.response;

import com.example.communityserver.domain.CommunityMember;
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
public class MemberResponse {
    private Long id;
    private String profileImage;
    private String communityName;
    private String nickname;
    private String code;
    @Enumerated(EnumType.STRING)
    private CommunityRole role;
    private String status;

    public static MemberResponse fromEntity(CommunityMember member, UserResponse user) {
        MemberResponse memberResponse = new MemberResponse();
        memberResponse.setId(user.getId());
        memberResponse.setProfileImage(user.getImage());
        memberResponse.setCommunityName(member.getNickname());
        memberResponse.setNickname(user.getName());
        memberResponse.setCode(user.getCode());
        memberResponse.setRole(member.getRole());
        memberResponse.setStatus("online");
        return memberResponse;
    }
}
