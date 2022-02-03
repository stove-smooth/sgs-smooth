//
//  ChannelAPI.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/31.
//

import Foundation
import Moya

enum ChannelTarget {
    // MARK: POST
    case createChannel(request: ChannelRequest)
}

extension ChannelTarget: BaseAPI, AccessTokenAuthorizable {
    var path: String {
        switch self {
        case .createChannel:
            return "/community-server/channel"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createChannel: return .post
        }
    }
    
    var task: Task {
        switch self {
        case .createChannel(let request):
            return .requestParameters(
                parameters: [
                    "id": request.id,
                    "name": request.name,
                    "type": request.type,
                    "public": request.public
                ], encoding: JSONEncoding.default)
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .createChannel:
            return .custom("")
        }
    }
}
