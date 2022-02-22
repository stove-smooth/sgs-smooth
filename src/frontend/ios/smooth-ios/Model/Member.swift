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

enum PresenceStatus: String, Codable {
    case online = "online"
    case offline = "offline"
    case unknown
    
    init(frome decoder: Decoder) throws {
        self = try PresenceStatus(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}

struct Member: Codable {
    let id: Int
    let profileImage: String?
    let communityName: String
    let nickname: String
    let code: String
    let role: MemberRole
    let status: PresenceStatus
}

struct Members: Codable {
    let members: [String]
}


struct MemberList: Codable {
    let members: [Member]
}
