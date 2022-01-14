//
//  UserAPI.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/03.
//

import Foundation
import Moya

enum UserTarget {
    case signIn(param: SignInRequest)
    case signUp(param: SignUpRequest)
    case sendMail(param: SendMailRequest)
    case verifyCode(param: VerifyCodeRequest)
    case fetchUserInfo
}

extension UserTarget: BaseAPI, AccessTokenAuthorizable {
    
    var path: String {
        switch self {
        case .signIn:
            return "/auth-server/sign-in"
        case .signUp:
            return "/auth-server/sign-up"
        case .sendMail:
            return "/auth-server/send-mail"
        case .verifyCode:
            return "/auth-server/check-email"
        case .fetchUserInfo:
            return "/auth-server/auth/info"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn: return .post
        case .signUp: return .post
        case .sendMail: return .post
        case .verifyCode: return .get
        case .fetchUserInfo: return .get
        }
    }
    
    var task: Task {
        switch self {
        case .signIn(let user):
            return .requestCustomJSONEncodable(user, encoder: JSONEncoder())
        case .signUp(let user):
            return .requestCustomJSONEncodable(user, encoder: JSONEncoder())
        case .sendMail(let request):
            return .requestParameters(parameters: ["email": request.email], encoding: URLEncoding.queryString)
        case .verifyCode(let request):
            return .requestParameters(parameters: ["key": request.key], encoding: URLEncoding.queryString)
        case .fetchUserInfo:
            return .requestPlain
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch  self {
        case .signIn, .signUp, .sendMail, .verifyCode:
            return nil
        case .fetchUserInfo:
            return .custom("Authorization")
        }
    }
}
