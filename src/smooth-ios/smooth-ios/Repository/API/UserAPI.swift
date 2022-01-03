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
}

extension UserAPI: BaseAPI {
    
    var path: String {
        switch self {
        case .signIn:
            return "/auth-server/sign-in"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn: return .post
        }
    }
    
    var task: Task {
        switch self {
        case .signIn(let user):
            return .requestCustomJSONEncodable(user, encoder: JSONEncoder())
        }
    }
}
