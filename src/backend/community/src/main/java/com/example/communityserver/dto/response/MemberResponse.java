package com.example.communityserver.dto.response;

import com.example.communityserver.domain.CommunityMember;
import com.example.communityserver.domain.type.CommunityRole;
import com.example.communityserver.domain.type.UserState;
import com.example.communityserver.util.UserStateUtil;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import java.util.Objects;

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
        if (!Objects.isNull(UserStateUtil.status.get(user.getId())))
            memberResponse.setStatus(UserStateUtil.status.get(user.getId()));
        else
            memberResponse.setStatus(UserState.OFFLINE);
        return memberResponse;
    }

    public static MemberResponse fromEntityV2(CommunityMember member, UserResponse user, String status) {
        MemberResponse memberResponse = new MemberResponse();
        memberResponse.setId(user.getId());
        memberResponse.setProfileImage(user.getImage());
        memberResponse.setCommunityName(member.getNickname());
        memberResponse.setNickname(user.getName());
        memberResponse.setCode(user.getCode());
        memberResponse.setRole(member.getRole());
        if (status.equals("온라인"))
            memberResponse.setStatus(UserState.ONLINE);
        else
            memberResponse.setStatus(UserState.OFFLINE);
        return memberResponse;
    }
}
