//
//  Category.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/31.
//

import Foundation

struct Category: Codable, Hashable {
    let id: Int
    let name: String
    var channels: [Channel]?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        lhs.id == rhs.id
    }
}


struct CategoryReqeust: Codable {
    let communityId: Int
    let name: String
    let `public`: Bool
    let menbers: [Int]?
}
