//
//  Channel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/24.
//

import Foundation
import RxDataSources

enum ChannelType: String, Codable {
    case text = "TEXT"
    case voice = "VOICE"
}

struct Channel: Codable, Equatable, IdentifiableType, Hashable {
    let id: Int
    let username: String?
    let name: String
    let type: ChannelType
    var parent: [Channel]? = nil
    let threads: [Thread]?
    let `public`: Bool
    
    var identity: Int {
        return self.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.id == rhs.id
    }
    
    init() {
        self.id = 0
        self.username = nil
        self.name = ""
        self.type = .text
        self.parent = nil
        self.threads = nil
        self.public = false
    }
}

struct Thread: Codable {
    let id: Int
    let name: String
}

struct ChannelRequest: Codable {
    let id: Int // 카테고리 ID
    let name: String
    let type: String
    let `public`: Bool
}
