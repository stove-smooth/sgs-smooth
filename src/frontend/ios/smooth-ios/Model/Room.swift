//
//  Room.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/13.
//

import Foundation


struct Room: Codable {
    let id: Int
    let group: Bool
    let members: [Int]
    let count: Int
    let name: String
    let icon: String?
    let state: PresenceStatus?
    let createdAt: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try! values.decode(Int.self, forKey: .id)
        group = try! values.decode(Bool.self, forKey: .group)
        members = try! values.decode([Int].self, forKey: .members)
        count = try! values.decode(Int.self, forKey: .count)
        name = try! values.decode(String.self, forKey: .name)
        icon = try? values.decode(String.self, forKey: .icon)
        state = try? values.decode(PresenceStatus.self, forKey: .state)
        createdAt = try! values.decode(String.self, forKey: .createdAt)
    }
}


struct RoomList: Codable {
    let rooms: [Room]
}
