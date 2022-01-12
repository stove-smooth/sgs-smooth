package com.example.communityserver.dto.response;

import com.example.communityserver.domain.CommunityInvitation;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class InvitationResponse {
    private Long invitationId;
    private String nickname;
    private String userCode;
    private String profileImage;
    private String inviteCode;

    public InvitationResponse(
            CommunityInvitation communityInvitation,
            UserInfoListFeignResponse.UserInfoListResponse userInfo
    ) {
        this.invitationId = communityInvitation.getId();
        this.inviteCode = communityInvitation.getCode();
        this.nickname = userInfo.getName();
        this.userCode = userInfo.getCode();
        this.profileImage = userInfo.getImage();
    }
}
