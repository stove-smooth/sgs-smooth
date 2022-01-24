//
//  ServerAPI.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/24.
//

import Foundation
import Moya

enum ServerTarget {
    case fetchServer
    case getServerById(param: Int)
}

extension ServerTarget: BaseAPI, AccessTokenAuthorizable {
    
    var path: String {
        switch self {
        case .fetchServer:
            return "/community-server/community"
        case .getServerById(let serverId):
            return "/community-server/community/\(serverId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchServer: return .get
        case .getServerById: return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchServer:
            return .requestPlain
        case .getServerById:
            return .requestPlain
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .fetchServer:
            return .custom("")
        case .getServerById:
            return .custom("")
        }
    }
}
