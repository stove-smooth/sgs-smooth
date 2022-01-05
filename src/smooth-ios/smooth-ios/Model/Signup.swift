//
//  Signup.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import Foundation

struct SignUpRequest: Encodable {
    let email: String
    let password: String
    
    var paramters: [String: Any] {
        return [
            "email": email,
            "password": password
        ]
    }
}

struct SignUpResponse: Decodable {
    
}

struct SendMailRequest: Encodable {
    let email: String
    
    var paramters: [String: Any] {
        return [
            "email": email,
        ]
    }
}

struct SendMailResponse: Decodable {
    
}
