package com.example.communityserver.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class ChannelDetailResponse extends ChannelResponse {
    private ChannelResponse parent;
    private List<ThreadDetailResponse> threads;
    private List<MemberResponse> members;

    public void setParent(ChannelResponse parent) {
        this.parent = parent;
    }

    public void setThreadDetails(List<ThreadDetailResponse> threads) {
        this.threads = threads;
    }

    public void setMembers(List<MemberResponse> members) {
        this.members = members;
    }
}
