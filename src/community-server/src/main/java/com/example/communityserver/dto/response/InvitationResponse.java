package com.example.communityserver.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class InvitationResponse {
    private String nickname;
    private String userCode;
    private String profileImage;
    private String inviteCode;

    public InvitationResponse(
            String inviteCode,
            UserInfoListFeignResponse.UserInfoListResponse userInfo
    ) {
        this.nickname = userInfo.getName();
        this.userCode = userInfo.getCode();
        this.profileImage = userInfo.getImage();
        this.inviteCode = inviteCode;
    }
}
