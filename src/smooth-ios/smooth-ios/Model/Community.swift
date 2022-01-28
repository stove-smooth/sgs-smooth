//
//  Community.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/24.
//

import Foundation

struct Community: Codable {
    let communities: [Server]
}

struct CommunityInfo: Codable {
    let id: Int
    let name: String
    let categories: [Category]
    
    init() {
        self.id = 0
        self.name = ""
        self.categories = []
    }
}
