//
//  Channel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/24.
//

import Foundation

enum ChannelType: String, Codable {
    case text = "TEXT"
    case voice = "VOICE"
}
/**
struct Channel: Codable {
    let id: Int
    let username: String?
    let name: String
    let type: ChannelType
    var parent: [Channel]? = nil
    let threads: [Thread]?
    let `public`: Bool
}
*/
struct Category: Codable {
    let id: Int
    let name: String
    let channels: [Channel]?
}

struct Thread: Codable {
    let id: Int
    let name: String
}


 
 
 
