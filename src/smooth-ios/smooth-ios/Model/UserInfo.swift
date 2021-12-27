//
//  UserInfo.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import Foundation

struct User: Codable {
    let id: Int
    let email: String
    let isAdmin: Bool
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "email"
        case isAdmin = "is_admin"
    }
    
    init() {
        self.id = -1
        self.email = ""
        self.isAdmin = false
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.email = try values.decodeIfPresent(String.self, forKey: .email) ?? ""
        self.isAdmin = try values.decodeIfPresent(Bool.self, forKey: .isAdmin) ?? false
    }
}
