//
//  FriendAPI.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/14.
//

import Foundation
import Moya

enum FriendTarget {
    case fetchFriend
    case deleteFriend(param: Int)
    case requestFriend(param: RequestFriend)
    case banFriend(param: Int)
    case acceptFriend(param: Int)
}

extension FriendTarget: BaseAPI, AccessTokenAuthorizable {
    
    var path: String {
        switch self {
        case .fetchFriend:
            return "/auth-server/auth/friend"
        case .deleteFriend:
            return "/auth-server/auth/friend"
        case .requestFriend:
            return "/auth-server/auth/friend"
        case .banFriend:
            return "/auth-server/auth/ban-friend"
        case .acceptFriend:
            return "/auth-server/auth/friend"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchFriend: return .get
        case .deleteFriend: return .delete
        case .requestFriend: return .post
        case .banFriend: return .patch
        case .acceptFriend: return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .fetchFriend:
            return .requestPlain
        case .deleteFriend(let friendId):
            return .requestParameters(parameters: ["id": friendId], encoding: URLEncoding.queryString)
        case .requestFriend(let request):
            return .requestCustomJSONEncodable(request, encoder: JSONEncoder())
        case .banFriend(let friendId):
            return .requestParameters(parameters: ["id": friendId], encoding: URLEncoding.queryString)
        case .acceptFriend(let friendId):
            return .requestParameters(parameters: ["id": friendId], encoding: URLEncoding.queryString)
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .fetchFriend:
            return .custom("")
        case .deleteFriend:
            return .custom("")
        case .requestFriend:
            return .custom("")
        case .banFriend:
            return .custom("")
        case .acceptFriend:
            return .custom("")
        }
    }
}
