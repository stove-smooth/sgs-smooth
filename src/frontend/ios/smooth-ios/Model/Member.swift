//
//  Member.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/30.
//

import Foundation

enum MemberRole: String, Codable {
    case owner = "OWNER"
    case none = "NONE"
}

enum MemberStatus: String, Codable {
    case online = "online"
    case offline = "offline"
}

struct Member: Codable {
    let id: Int
    let profileImage: String?
    let communityName: String
    let nickname: String
    let code: String
    let role: MemberRole
    let status: MemberStatus
}


struct MemberList: Codable {
    let members: [Member]
}
