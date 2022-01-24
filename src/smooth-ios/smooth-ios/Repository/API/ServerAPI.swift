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
}

extension ServerTarget: BaseAPI, AccessTokenAuthorizable {
    
    var path: String {
        switch self {
        case .fetchServer:
            return "/community-server/community"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchServer: return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchServer:
            return .requestPlain
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .fetchServer:
            return .custom("")
        }
    }
}
