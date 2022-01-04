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

struct SignInResponse: Decodable {
    let id: Int
    let name: String
    let code: String
    let email: String
    
    let accessToken: String
    let refreshToken: String
}
