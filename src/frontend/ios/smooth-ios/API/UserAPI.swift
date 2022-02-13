//
//  UserAPI.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/03.
//

import Foundation
import Moya

enum UserTarget {
    // MARK: POST
    case signIn(email: String, password: String)
    case signUp(email: String, password: String, name: String)
    case sendMail(email: String)

    // MARK: GET
    case verifyCode(key: String)
    case fetchUserInfo
    case fetchUserInfoById(userId: Int)
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
        case .fetchUserInfoById:
            return "/auth-server/name"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn: return .post
        case .signUp: return .post
        case .sendMail: return .post
        case .verifyCode: return .get
        case .fetchUserInfo: return .get
        case .fetchUserInfoById: return .get
        }
    }
    
    var task: Task {
        switch self {
        case .signIn(let email, let password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        case .signUp(let email, let password, let name):
            return .requestParameters(parameters: ["email": email, "password": password, "name": name], encoding: JSONEncoding.default)
        case .sendMail(let email):
            return .requestParameters(parameters: ["email": email], encoding: URLEncoding.queryString)
        case .verifyCode(let key):
            return .requestParameters(parameters: ["key": key], encoding: URLEncoding.queryString)
        case .fetchUserInfo:
            return .requestPlain
        case .fetchUserInfoById(let userId):
            return .requestParameters(parameters: ["id": userId], encoding: URLEncoding.queryString)
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch  self {
        case .signIn, .signUp, .sendMail, .verifyCode, .fetchUserInfoById:
            return nil
        case .fetchUserInfo:
            return .custom("")
        }
    }
}
