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
    
    // MARK: PATCH
    case updateLocation(originId: Int, nextId: Int, categoryId: Int)
}

extension ChannelTarget: BaseAPI, AccessTokenAuthorizable {
    var path: String {
        switch self {
        case .createChannel:
            return "/community-server/channel"
        case .updateLocation:
            return "/community-server/channel/location"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createChannel: return .post
        case .updateLocation: return .patch
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
        case .updateLocation(let originId, let nextId, let categoryId):
            return .requestParameters(parameters: ["id": originId, "next": nextId, "categoryId": categoryId], encoding: JSONEncoding.default)
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .createChannel:
            return .custom("")
        case .updateLocation:
            return .custom("")
        }
    }
}
