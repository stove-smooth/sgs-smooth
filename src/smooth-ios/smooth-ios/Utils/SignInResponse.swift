//
//  SignInResponse.swift
//  smooth-ios
//
//  Created by durikim-MN on 2021/12/30.
//

import Foundation

extension SmoothBackend.Responses {
    struct SignInResponse: Codable {
        let accessToken: String
        let refreshToken: String
    }
}
