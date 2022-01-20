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
    case deleteFriend(param: DeleteFriendRequest)
}

extension FriendTarget: BaseAPI, AccessTokenAuthorizable {
    
    var path: String {
        switch self {
        case .fetchFriend:
            return "/auth-server/auth/friend"
        case .deleteFriend:
            return "/auth-server/auth/friend"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchFriend: return .get
        case .deleteFriend: return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .fetchFriend:
            return .requestPlain
        case .deleteFriend(let request):
            return .requestParameters(parameters: ["id": request.id], encoding: URLEncoding.queryString)
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .fetchFriend:
            return .custom("")
        case .deleteFriend:
            return .custom("")
        }
    }
}
