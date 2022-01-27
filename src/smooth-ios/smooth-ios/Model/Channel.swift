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

struct Channel: Codable, Equatable, IdentifiableType {
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
    
    static func == (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Category: Codable {
    let id: Int
    let name: String
    let channels: [Channel]?
}

struct Thread: Codable {
    let id: Int
    let name: String
}
