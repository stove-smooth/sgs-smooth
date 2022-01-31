//
//  Category.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/31.
//

import Foundation

struct Category: Codable {
    let id: Int
    let name: String
    let channels: [Channel]?
}


struct CategoryReqeust: Codable {
    let communityId: Int
    let name: String
    let `public`: Bool
    let menbers: [Int]?
}
