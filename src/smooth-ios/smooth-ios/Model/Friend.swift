//
//  Friend.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/14.
//

import Foundation
import RxDataSources

enum FriendState: String, Codable {
    case wait = "WAIT" // (친구 요청 받은거)
    case request = "REQUEST" // (내가 친구 요청 보낸거)
    case accept = "ACCEPT" // (친구)
    case ban = "BAN"
    case none
}

struct Friend: Codable, Equatable, IdentifiableType {
    let id: Int
    let name: String
    let code: String
    let profileImage: String?
    let state: FriendState
    
    var identity: Int {
        return self.id
    }
    
    init() {
        self.id = 0
        self.code = ""
        self.name = ""
        self.profileImage = nil
        self.state = FriendState.none
    }
}

struct FriendListResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [Friend]
}

struct RequestFriend: Codable {
    let name: String
    let code: String
}
