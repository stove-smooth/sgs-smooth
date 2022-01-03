//
//  UserAPI.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/03.
//

import Foundation
import Moya

enum UserAPI {
    case signIn(param: SignInRequest)
    case signUp(param: SignUpRequest)
    case fetchUserInfo
}

extension UserAPI: BaseAPI {
    
    var path: String {
        switch self {
        case .signIn:
            return "/auth-server/sign-in"
        case .signUp:
            return "/auth-server/sign-up"
        case .fetchUserInfo:
            return "/auth-server/info"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn: return .post
        case .signUp: return .post
        case .fetchUserInfo: return .get
        }
    }
    
    var task: Task {
        switch self {
        case .signIn(let user):
            return .requestCustomJSONEncodable(user, encoder: JSONEncoder())
        case .signUp(let user):
            return .requestCustomJSONEncodable(user, encoder: JSONEncoder())
        case .fetchUserInfo:
            return .requestPlain
        }
    }
}
