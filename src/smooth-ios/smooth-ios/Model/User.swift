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
    let name: String
    let code: String
    let profileImage: String?
    let bio: String?
}
