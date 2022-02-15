//
//  SignIn.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import Foundation

struct SignIn: Codable {
    let id: Int
    let name: String
    let code: String
    let email: String
    
    let accessToken: String
    let refreshToken: String
    
    let deviceToken: String?
    let type: String?
    let url: String
}
