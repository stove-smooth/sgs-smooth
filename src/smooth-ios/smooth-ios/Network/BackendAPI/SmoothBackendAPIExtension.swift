//
//  SmoothBackendAPIExtension.swift
//  smooth-ios
//
//  Created by durikim-MN on 2021/12/30.
//

import Foundation
import Moya

extension SmoothBackendAPI.Auth: APIEndpoint {
    var requiredAuthTokenType: AuthTokenType {
        switch self {
        case .signin:
            return .none
        case .signOut:
            return .none
        }
    }
    
    var path: String {
        switch self {
        case .signin:
            return "/auth-server/sign-in"
        case .signOut:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signin:
            return .post
        case .signOut:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .signin(let user, _):
            return .requestCustomJSONEncodable(user, encoder: parametersEncoder)
        case .signOut:
            return .requestPlain
        }
    }
}
