//
//  SignIn.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import Foundation

struct SignInRequest: Encodable {
    let email: String
    let password: String
    
    var paramters: [String: Any] {
        return [
            "email": email,
            "password": password
        ]
    }
    
}

struct SignInResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: SignIn
}

struct SignIn: Codable {
    let id: Int
    let name: String
    let code: String
    let email: String
    
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
            case id, name, code, email, accessToken, refreshToken
        }
}
