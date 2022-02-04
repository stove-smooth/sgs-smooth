//
//  Message.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/01.
//

import Foundation

struct Message: Codable {
    let id: String
    let name: String
    let profileImage: String
    let userId: Int
    let message: String
    let time: String
    let parentName: String?
    let parentContent: String?
}
