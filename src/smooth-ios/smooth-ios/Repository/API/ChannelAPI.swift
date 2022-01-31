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
    case createChannel(categoryId: Int, channel: Channel)
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
        case .createChannel(let categoryId, let channel):
            return .requestParameters(
                parameters: [
                    "id": categoryId,
                    "name": channel.name,
                    "type": channel.type,
                    "public": channel.public
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
