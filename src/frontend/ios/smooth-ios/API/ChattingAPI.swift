//
//  ChattingAPI.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/01.
//

import Foundation
import Moya

enum ChattingTarget {
    case fetchMessgae(channelId: Int, page: Int, size: Int)
}

extension ChattingTarget: BaseAPI, AccessTokenAuthorizable {
    var path: String {
        switch self {
        case .fetchMessgae:
            return "/chat-server/community"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchMessgae: return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchMessgae(let channelId, let page, let size):
            return .requestParameters(parameters: [
                "ch_id": channelId,
                "page": page,
                "size": size
            ], encoding: URLEncoding.queryString)
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .fetchMessgae:
            return .none
        }
    }
}
